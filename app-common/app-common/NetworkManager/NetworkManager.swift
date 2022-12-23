//
//  NetworkManager.swift
//  app-common
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

public typealias ServiceResponse = (NSError?, Any?) -> Void

/// Public class to facilitate API calls
public class NetworkManager {
    
    /// Bool to determine if the serice is called for tests.
    public static var isRunningTests: Bool = false
    
    /// Public method to initiate an API request
    /// - Parameters:
    ///   - service: Service Protocol class
    ///   - serviceResponse: Response with error and data
    public static func callService(_ service: ApiRequestProtocol, serviceResponse: @escaping ServiceResponse) {
        
        // Send mock response if running test cases
        if isRunningTests {
            print("Running XCTest. Fetching from JSON!")
            respondWithMockData(for: service, serviceResponse: serviceResponse)
            return
        }
        
        // Proceed with request if not running tests.
        guard let request = createRequest(with: service) else { return }
        let apiRequestTask = URLSession.shared.dataTask(with: request) { data, response, error in
            responseHandler(service: service, data: data,
                            response: response, error: error,
                            serviceResponse: serviceResponse)
        }
        apiRequestTask.resume()
    }
    
    /// Private method to create the URL request
    /// - Parameter service: ServiceProtocol class
    /// - Returns: URL Request
    fileprivate static func createRequest(with service: ApiRequestProtocol) -> URLRequest? {
        
        guard let requestUrl = URL(string: service.urlString) else { return nil }
        
        // Create and configure request
        var request = URLRequest(url: requestUrl)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = service.requestType.rawValue
        request.setValue(service.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(service.acceptType, forHTTPHeaderField: "Accept")
        
        // Add HTTP Headers
        if let headers = service.httpHeaders {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Include the HTTPBody
        if let requestParams = service.requestParams,
           let encoded = service.requestEncoder(requestParams) {
            request.httpBody = encoded
        }
        
        return request
    }
    
    /// Private method to handle the response from server
    /// - Parameters:
    ///   - service: Service Protocol class
    ///   - data: data received from server
    ///   - response: HTTPResponse
    ///   - error: Error object
    ///   - serviceResponse: completion handler
    fileprivate static func responseHandler(service: ApiRequestProtocol,
                                            data: Data?,
                                            response: URLResponse?,
                                            error: Error?,
                                            serviceResponse: @escaping ServiceResponse) {
        // Return immediately if error
        if let error = error as NSError? {
            DispatchQueue.main.async {
                serviceResponse(error, nil)
            }
            return
        }
        
        // Check if we have valid HTTPURLResponse
        guard let urlResponse = response as? HTTPURLResponse else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])
            DispatchQueue.main.async {
                serviceResponse(error, nil)
            }
            return
        }
        
        // Now check for the DATA response
        guard let responseData = data else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Response data returned nil"])
            DispatchQueue.main.async {
                serviceResponse(error, nil)
            }
            return
        }
        
        // Check if the status code is 200
        let statusCode = urlResponse.statusCode
        guard statusCode == 200 else {
            let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Returned status code \(statusCode) from server"])
            DispatchQueue.main.async {
                serviceResponse(error, nil)
            }
            return
        }
        
        guard let parsedResponse = service.responseDecoder(responseData) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Response could not be parsed."])
            DispatchQueue.main.async {
                serviceResponse(error, nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            serviceResponse(nil, parsedResponse)
        }
    }
}

// MARK: Mock response methods.

extension NetworkManager {
    
    /// Method to return mock response if running test cases.
    /// - Parameters:
    ///   - service: service protocol
    ///   - serviceResponse: response data
    private static func respondWithMockData(for service: ApiRequestProtocol, serviceResponse: @escaping ServiceResponse) {
        guard let response = loadDataFromJson(for: service) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock data fetch failed."])
            DispatchQueue.main.async {
                serviceResponse(error, nil)
            }
            return
        }
        print("Running XCTest. JSON returned data!")
        DispatchQueue.main.async {
            serviceResponse(nil, response)
        }
    }
    
    /// Private methosd to load data from JSON file.
    /// - Parameter service: service protocol
    /// - Returns: Any data.
    private static func loadDataFromJson(for service: ApiRequestProtocol) -> Any? {
        guard let filename = service.mockJsonFileName,
              let path = Bundle.main.path(forResource: filename, ofType: "json"),
              let data = try? Data.init(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let parsedResponse = service.responseDecoder(data) else {
            return nil
        }
        return parsedResponse
    }
    
}
