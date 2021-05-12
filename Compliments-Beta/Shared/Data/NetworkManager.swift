//
//  Network.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 11/14/20.
//

import Foundation
import Combine
import SwiftUI

class NetworkManager: ObservableObject {
    
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
        case delete = "DELETE"
    }

    var subscriber: AnyCancellable?
    
    @Published var isComplete: Bool = false
    @Published var isSending: Bool = false
    
    
    func sendCompliment(with employeeId: Int, employerId: Int, comment: String, rating: Double) {
        guard let url = URL(string: "https://www.we-compliment.com/api/appPort") else { return }
        
        var params: [String: Any] = [:]
        params["email"] = "bryan.d.burnham@gmail.com"
        params["password"] = "Phishing4Compliments!1100"
        params["employer_id"] = employerId
        params["employee_id"] = employeeId
        params["comment"] = comment
        params["rating"] = rating
        
        var request = URLRequest(url: url.parameterEncoded(with: params) ?? url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(NetworkKeys.applicationJSON, forHTTPHeaderField: NetworkKeys.contentTypeHeader)
        
        let session = URLSession(configuration: .default)
        isSending = true
        subscriber = session.dataTaskPublisher(for: request)
            .tryMap { output -> Any in
                if let error = self.error(for: output.response, data: output.data) {
                    throw error
                }
                return try JSONSerialization.jsonObject(with: output.data, options: [])
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.isSending = false
            }, receiveValue: { response in
                print(response)
                withAnimation(.spring()) {
                    self.isComplete = true
                    self.isSending = false
                }
            })
    }
    
    private func error(for response: URLResponse?, data: Data) -> APIError? {
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
