//
//  Network.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 11/14/20.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation
import AppClip

class NetworkManager: ObservableObject {
    
    // MARK: - Enums
    
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
        case delete = "DELETE"
    }

    // MARK: - Private properties
    
    private var subscribers = Set<AnyCancellable>()
    private let session = URLSession(configuration: .default)
    private let url = URL(string: "https://www.we-compliment.com/api/appPort")
    private var clientId: String? = nil
    private var employeeId: String? = nil
    
    // MARK: - Published
    
    @Published var isComplete: Bool = false
    @Published var isSending: Bool = false
    @Published var isValidating: Bool = false
    @Published var isValidLocation: Bool = false
    @Published var failedFromInvalidLocation: Bool = false
    @Published var clientName: String? = nil
    @Published var employeeName: String? = nil
    @Published var errorMessage: String? = nil
    @Published var response: String? = nil
    
    
    // MARK: - Init
    
    init(isValid: Bool = false) {
        isValidLocation = isValid
        if isValid {
            clientId = "1"
            employeeId = "2"
        }
    }

    
    // MARK: - Functions
    
    func sendCompliment(comment: String, rating: Double) {
        guard let url = url, let clientId = clientId, let employeeId = employeeId else { return }
        
        var params: [String: Any] = [:]
        params["email"] = "bryan.d.burnham@gmail.com"
        params["password"] = "Phishing4Compliments!1100"
        params["employer_id"] = clientId
        params["employee_id"] = employeeId
        params["comment"] = comment
        params["rating"] = rating
        
        var request = URLRequest(url: url.parameterEncoded(with: params) ?? url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(NetworkKeys.applicationJSON, forHTTPHeaderField: NetworkKeys.contentTypeHeader)
        
        
        isSending = true
        withAnimation(.spring().delay(0.5)) {
            self.isComplete = true
            self.isSending = false
        }
        return
        session.dataTaskPublisher(for: request)
            .tryMap { output -> Any in
                if let error = self.error(for: output.response, data: output.data) {
                    throw error
                }
                return try JSONSerialization.jsonObject(with: output.data, options: [])
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.isSending = false
                print(completion)
            }, receiveValue: { response in
                print(response)
                withAnimation(.spring()) {
                    self.isComplete = true
                    self.isSending = false
                }
                self.clientId = nil
                self.employeeId = nil
            })
            .store(in: &subscribers)
    }
    
    func getClientDetails(clientId: String, employeeId: String, activity: NSUserActivity) {
        guard let url = url else { return }
        
        var params: [String: Any] = [:]
        params["email"] = "bryan.d.burnham@gmail.com"
        params["password"] = "Phishing4Compliments!1100"
        params["employer_id"] = clientId
        params["employee_id"] = employeeId
        
        var request = URLRequest(url: url.parameterEncoded(with: params) ?? url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(NetworkKeys.applicationJSON, forHTTPHeaderField: NetworkKeys.contentTypeHeader)
        
        self.clientId = clientId
        self.employeeId = employeeId
        self.isValidating = true
        
        session.dataTaskPublisher(for: request)
            .tryMap { output in
                if let error = self.error(for: output.response, data: output.data) {
                    throw error
                }
                return output.data
            }
            .decode(type: ClientDetails.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { clientDetails in
                self.clientName = clientDetails.client
                self.employeeName = clientDetails.employee
                self.response = clientDetails.debugDescription
            })
//            .tryMap { clientDetails in
//                guard let latitude = CLLocationDegrees(clientDetails.latitude), let longitude = CLLocationDegrees(clientDetails.longitude) else { throw APIError.validationFailed("Could not find location based on coordinates from server")}
//                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                return CLCircularRegion(center: coordinates, radius: 1000, identifier: clientId)
//            }
//            .flatMap { region in
//                self.verifyLocation(region: region, activity: activity)
//            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
                self.isValidating = false
                switch completion {
                case let .failure(error):
                    print(error)
                    if let apiError = error as? APIError {
                        switch apiError {
                        case let .invalidLocation(locationError):
                            withAnimation {
                                self.failedFromInvalidLocation = true
                            }
                            self.errorMessage = "\(locationError.debugDescription)"
                        default:
                            self.errorMessage = error.localizedDescription
                        }
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                case .finished:
                    self.isValidLocation = true
                }
            }, receiveValue: { isValid in })
            .store(in: &subscribers)
    }
    
    func loadTest() {
        clientName = "Compliment"
        clientId = "1"
        employeeId = "2"
        isValidLocation = true
    }
    
    func reset() {
        isComplete = false
        isSending = false
        clientName = nil
        clientId = nil
        employeeId = nil
        isValidLocation = false
        failedFromInvalidLocation = false
        errorMessage = nil
        response = nil
    }
    
}

private extension NetworkManager {
    
    func verifyLocation(region: CLRegion, activity: NSUserActivity) -> AnyPublisher<Bool, Error> {
        Future { promise in
            guard let payload = activity.appClipActivationPayload else {
                promise(.failure(APIError.unsuccessfulRequest("No app clip activation payload found")))
                return
            }
            payload.confirmAcquired(in: region) { inRegion, error in
                if let error = error as? APActivationPayloadError {
                    print(error.code)
                    promise(.failure(APIError.invalidLocation(error)))
                }
                if inRegion {
                    promise(.success(true))
                } else {
                    promise(.failure(APIError.invalidLocation(nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func error(for response: URLResponse?, data: Data) -> APIError? {
        guard let response = response as? HTTPURLResponse else {
            return APIError.networkError(nil)
        }
        switch response.statusCode {
        case 500..<599:
            return APIError.serverError(response.curlOutput(with: data))
        case 400, 422:
            let detail = String(data: data, encoding: .utf8)
            return APIError.validationFailed(detail)
        case 200..<299:
            return nil
        default:
            return APIError.unsuccessfulRequest(response.curlOutput(with: data))
        }
    }
    
}

struct NetworkKeys {
    static let acceptHeader = "Accept"
    static let applicationJSON = "application/json"
    static let authorization = "Authorization"
    static let bearer = "Bearer"
    static let contentTypeHeader = "Content-Type"
    static let contentLength = "Content-Length"
    static let networkMonitorQueue = "NetworkMonitorQueue"
    static let requestIdHeader = "X-Request-Id"
}

extension URL {
    
    func parameterEncoded(with jsonObject: [String: Any]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var queryItems = [URLQueryItem]()
        for (name, value) in jsonObject {
            let queryItem = URLQueryItem(name: name, value: String(describing: value))
            queryItems.append(queryItem)
        }
        
        components?.queryItems = queryItems
        return components?.url
    }
    
}

/// Networking errors based on status codes and `URLError`s received.
public enum APIError: Error {
    case decodingError(Error?) // Error caused by a failure to decode a `Decodable`
    case invalidURL(url: URL) // The `URLConvertible` could not be converted into a `URL`
    case networkError(Error?) // A generic error when no response is returned from the network
    case noInternetConnection
    case refreshFailed // Call to refresh an access token fails
    case responseCorrupted // The response received from the network can not be read
    case serverError(String?) // A 500~ error
    case unsuccessfulRequest(String?) // An error response with a status other than a 500 or 400 or 200
    case validationFailed(String?) // A 400~ error
    case invalidLocation(Error?)
}


internal extension HTTPURLResponse {

    /// Converts the data from a network response into a curl String
    func curlOutput(with data: Data?) -> String? {
        var output = "HTTP/1.1 \(statusCode) \(HTTPURLResponse.localizedString(forStatusCode: statusCode))\n"
        for (key, value) in allHeaderFields {
            output += "\(key): \(value)\n"
        }
        if let data = data {
            output += "\n"
            output += String(data: data, encoding: .utf8)!
            output += "\n"
        }
        return output
    }

}


struct ClientDetails: Codable {
    
    let client: String
    let employee: String
    let latitude: String
    let longitude: String
    
    var debugDescription: String {
        "client: \(client)\n employee: \(employee)\n gps: \(latitude), \(longitude)"
    }
    
}
