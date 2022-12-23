//
//  ApiRequestProtocol.swift
//  app-common
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

public enum HTTPRequestType: String {
    case GET = "GET"
    case POST = "POST"
}

/// Protocol to define the different aspects for an API call.
public protocol ApiRequestProtocol {
    /// URL to be fetched.
    var urlString: String { get }
    
    /// GET (or) POST
    var requestType: HTTPRequestType { get }
    
    /// For ContentType header
    var contentType: String { get }
    
    /// For Accept header
    var acceptType: String { get }
    
    /// HTTP body
    var requestParams: [String: Any]? { get }
    
    /// Additional HTTP headers.
    var httpHeaders: [String: String]? { get }
    
    /// Local JSON file for mock response.
    var mockJsonFileName: String? { get }
    
    /// Method to encode the request Param to JSON
    /// - Returns: Data object for HTTP Body
    func requestEncoder(_ requestParams: [String: Any]) -> Data?
    
    /// Method to decode the response
    /// - Returns: Codeable onject
    func responseDecoder(_ response: Data) -> Any?
}
