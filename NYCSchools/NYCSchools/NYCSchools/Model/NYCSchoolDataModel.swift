//
//  NYCSchoolDataModel.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

struct NYCSchoolDataModel: Codable {
    var dbn: String?
    var schoolName: String?
    var overviewParagraph: String?
    var location: String?
    var phoneNumber: String?
    var schoolEmail: String?
    var website: String?
    
    private enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case overviewParagraph = "overview_paragraph"
        case location
        case phoneNumber = "phone_number"
        case schoolEmail = "school_email"
        case website
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dbn = try container.decodeIfPresent(String.self, forKey: .dbn)
        schoolName = try container.decodeIfPresent(String.self, forKey: .schoolName)
        overviewParagraph = try container.decodeIfPresent(String.self, forKey: .overviewParagraph)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        schoolEmail = try container.decodeIfPresent(String.self, forKey: .schoolEmail)
        website = try container.decodeIfPresent(String.self, forKey: .website)
    }
}

