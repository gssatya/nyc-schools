//
//  SchoolDetailsTableDataModel.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/25/22.
//

import Foundation

/// Enum for different sections of data in School Details VC
enum SchoolDetailsTableSection: String, CaseIterable {
    case overview
    case satScores
    case contact
}

/// Enum for different types of contact
enum SchoolDetailsContactType {
    case location
    case phone
    case email
    case website
}

/// Struct for displaying the overview paragragh
struct SchoolDetailsOverview {
    var schoolName: String
    var overview: String
}

/// Struct for displaying the SAT Scores
struct SchoolDetailsSATScores {
    var scoreName: String
    var scoreValue: String
}

/// Struct for displaying the Contact details.
struct SchoolDetailsContact {
    var contactName: String
    var contactValue: String
    var contactType: SchoolDetailsContactType 
}
