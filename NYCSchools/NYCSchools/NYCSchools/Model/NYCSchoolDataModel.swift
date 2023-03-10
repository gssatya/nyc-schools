//
//  NYCSchoolDataModel.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

///
/// Response Data model from the API
/// https://data.cityofnewyork.us/resource/s3k6-pzi2.json
///
struct NYCSchoolDataModel: Codable {
    
    var dbn: String?
    var schoolName: String?
    var overviewParagraph: String?
    var location: String?
    var phoneNumber: String?
    var schoolEmail: String?
    var website: String?
    var strength: String?
    var safetyScore: String?
    
    private enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case overviewParagraph = "overview_paragraph"
        case location
        case phoneNumber = "phone_number"
        case schoolEmail = "school_email"
        case website
        case strength = "total_students"
        case safetyScore = "pct_stu_safe"
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
        strength = try container.decodeIfPresent(String.self, forKey: .strength)
        safetyScore = try container.decodeIfPresent(String.self, forKey: .safetyScore)
    }
    
    internal init(dbn: String? = nil, schoolName: String? = nil, overviewParagraph: String? = nil, location: String? = nil, phoneNumber: String? = nil, schoolEmail: String? = nil, website: String? = nil, strength: String? = nil, safetyScore: String? = nil) {
        self.dbn = dbn
        self.schoolName = schoolName
        self.overviewParagraph = overviewParagraph
        self.location = location
        self.phoneNumber = phoneNumber
        self.schoolEmail = schoolEmail
        self.website = website
        self.strength = strength
        self.safetyScore = safetyScore
    }
}

