//
//  SchoolsListService.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation
import app_common

/// Service class confirming to ApiRequestProtocol
/// To fetch the Schools List data from server.
class SchoolsListService: ApiRequestProtocol {
    
    var urlString: String {
        return "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    }
    
    var requestType: HTTPRequestType {
        return .GET
    }
    
    var contentType: String {
        return "application/json"
    }
    
    var acceptType: String {
        return "application/json"
    }
    
    var requestParams: [String : Any]? = nil
    
    var httpHeaders: [String : String]? = nil
    
    var mockJsonFileName: String? {
        return "MockSchoolsList"
    }
    
    func requestEncoder(_ requestParams: [String: Any]) -> Data? {
        return nil
    }
    
    func responseDecoder(_ response: Data) -> Any? {
        guard let json = try? JSONSerialization.jsonObject(with: response, options: .allowFragments),
              let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let defaultResponseObject = try? JSONDecoder().decode([NYCSchoolDataModel].self, from: data) else {
                  return nil
              }
        return defaultResponseObject
    }

}

