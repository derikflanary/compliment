//
//  Network.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 11/14/20.
//

import Foundation
import SwiftUI
import CoreLocation
import AppClip
import NetworkStackiOS

class ComplimentService: ObservableObject {
    
    enum ClientType: String {
        case one
        case two
        case three
        
        var explanationText: String {
            switch self {
            case .one:
                return Localized.tellUsWhy
            case .two:
                return Localized.recognizeExplanation
            case .three:
                return Localized.recognizeExplanation
            }
        }
    }
    
    // MARK: - Private properties
    
    private let session = URLSession(configuration: .default)
    private let url = URL(string: "https://www.we-compliment.com/api/appPort")
    private var clientId: String? = nil
    private var employeeId: String? = nil
    private var network: NetworkManager {
        let networkEnvironment = NetworkEnvironment()
        return NetworkManager(environment: networkEnvironment)
    }
    
    // MARK: - Published
    
    @Published var isComplete: Bool = false
    @Published var isSending: Bool = false
    @Published var isValidating: Bool = false
    @Published var failedFromInvalidLocation: Bool = false
    @Published var clientName: String? = nil
    @Published var employeeName: String? = nil
    @Published var errorMessage: String? = nil
    @Published var response: String? = nil
    @Published var clientType: ClientType = .one
    
    
    // MARK: - Init
    
    init(isValid: Bool = false) {
        if isValid {
            clientId = "one"
            employeeId = "2"
        }
    }

    
    // MARK: - Functions
    
    func sendCompliment(comment: String, rating: Double) async {
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
        
        DispatchQueue.main.async {
            withAnimation {
                self.isSending = true
            }
        }
        
        do {
            if ClientType(rawValue: clientId) != nil {
                try await Task.sleep(nanoseconds: 2_000_000_000)
            } else {
                let (data, response) = try await network.perform(request)
                try JSONSerialization.jsonObject(with: data, options: [])
                print(response)
            }
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.isComplete = true
                    self.isSending = false
                }
                self.clientId = nil
                self.employeeId = nil
            }
        } catch {
            print(error)
        }
    }
    
    func getClientDetails(clientId: String, employeeId: String, activity: NSUserActivity) async {
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
        
        do {
            let clientDetails = try await network.request(request, responseAs: ClientDetails.self, decoder: JSONDecoder())
            DispatchQueue.main.async {
                withAnimation {
                    self.clientName = clientDetails.client
                    self.employeeName = clientDetails.employee
                    self.response = clientDetails.debugDescription
                    self.isValidating = false
                }
            }
        } catch {
            print(error)
        }
    }
    
    func loadTest(clientId: String, employeeId: String) {
        let clientType = ClientType(rawValue: clientId) ?? .one
        clientName = "Compliment"
        self.clientId = clientId
        self.employeeId = employeeId
        self.clientType = clientType
    }
    
    func reset() {
        isComplete = false
        isSending = false
        clientName = nil
        clientId = nil
        employeeId = nil
        failedFromInvalidLocation = false
        errorMessage = nil
    }
    
}

private extension ComplimentService {
    
    func verifyLocation(region: CLRegion ,activity: NSUserActivity) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            guard let payload = activity.appClipActivationPayload else {
                continuation.resume(returning: false)
                return
            }
            payload.confirmAcquired(in: region) { inRegion, error in
                if let error = error as? APActivationPayloadError {
                    print(error.code)
                    continuation.resume(throwing: error)
                }
                continuation.resume(returning: inRegion)
            }
        }
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

struct NetworkEnvironment: APIEnvironment {
    
    var baseURL: URL? {
        nil
    }
    
}
