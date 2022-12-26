//
//  SATResultsDataModel.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

struct SATResultsDataModel: Codable {
    var dbn: String?
    var schoolName: String?
    var testTakers: String?
    var readingAvg: String?
    var mathAvg: String?
    var writingAvg: String?
    
    private enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case testTakers = "num_of_sat_test_takers"
        case readingAvg = "sat_critical_reading_avg_score"
        case mathAvg = "sat_math_avg_score"
        case writingAvg = "sat_writing_avg_score"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dbn = try container.decodeIfPresent(String.self, forKey: .dbn)
        schoolName = try container.decodeIfPresent(String.self, forKey: .schoolName)
        testTakers = try container.decodeIfPresent(String.self, forKey: .testTakers)
        readingAvg = try container.decodeIfPresent(String.self, forKey: .readingAvg)
        mathAvg = try container.decodeIfPresent(String.self, forKey: .mathAvg)
        writingAvg = try container.decodeIfPresent(String.self, forKey: .writingAvg)
    }
}
