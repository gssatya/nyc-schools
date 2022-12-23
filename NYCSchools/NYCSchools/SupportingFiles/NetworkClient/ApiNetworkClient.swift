//
//  ApiNetworkClient.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation
import app_common

/// Client manager class for handling network request.
class ApiNetworkClient {
    
    /// Method to initiate an API request
    /// - Parameters:
    ///   - service: Service Protocol class
    ///   - allowOfflineLoad: Bool to determine if caching in needed.
    ///   - responseType: Decodable type
    ///   - completion: callback with data and error.
    static func callService<T: Codable>(with service: ApiRequestProtocol,
                                        allowOfflineLoad: Bool = false,
                                        responseType: T.Type,
                                        completion: @escaping ((Error?, T?) -> Void)) {
        
        // Try fetching data from server.
        NetworkManager.callService(service) { error, response in
            guard error == nil, let response = response as? T else {
                // Use the cache data if the server call fails.
                fetchOfflineDataOnError(for: service,
                                           error: error,
                                           allowOfflineLoad: allowOfflineLoad,
                                           completion: completion)
                return
            }
            
            // Update the data in File cache if needed.
            if allowOfflineLoad {
                updateCacheData(for: service, with: response)
            }
            
            // Sending back response.
            completion(nil, response)
        }
    }
    
    /// Private method to return the data from File cache in case of error.
    /// - Parameters:
    ///   - service: Service Protocol class
    ///   - error: Error object from server
    ///   - allowOfflineLoad: Bool to determine if caching in needed.
    ///   - completion: callback with data and error.
    private static func fetchOfflineDataOnError<T: Decodable>(for service: ApiRequestProtocol,
                                                              error: Error?,
                                                              allowOfflineLoad: Bool,
                                                              completion: @escaping ((Error?, T?) -> Void)) {
        guard allowOfflineLoad else {
            completion(error, nil)
            return
        }
        
        print("Network fetch failed. Fetching from File Cache!")
        let fileName = getFileName(from: service.urlString)
        guard let responseData = FileStorageManager.retrieve(fileName, as: T.self) else {
            completion(error, nil)
            return
        }
        
        print("File cache retrieved!")
        completion(nil, responseData)
    }
    
    /// Private method to cache the data if needed.
    /// - Parameters:
    ///   - service: Service Protocol class
    ///   - data: Encodable object
    private static func updateCacheData<T: Encodable>(for service: ApiRequestProtocol,
                                                      with data: T) {
        print("Updating cache in File System!")
        let fileName = getFileName(from: service.urlString)
        do {
            try FileStorageManager.store(data, filename: fileName)
        } catch {
            print("Failed storing the cache!")
        }
    }
    
    /// Create a file from the URL String
    /// - Parameter urlString: URL String
    /// - Returns: trimmed file name
    private static func getFileName(from urlString: String) -> String {
        let chars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return String(urlString.filter { chars.contains($0) })
    }
}

