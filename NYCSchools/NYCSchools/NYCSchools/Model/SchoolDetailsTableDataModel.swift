//
//  SchoolDetailsTableDataModel.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/25/22.
//

import Foundation

enum SchoolDetailsTableSection: String, CaseIterable {
    case overview
    case satScores
    case contact
}

enum SchoolDetailsContactType {
    case location
    case phone
    case email
    case website
}

struct SchoolDetailsOverview {
    var schoolName: String
    var overview: String
}

struct SchoolDetailsSATScores {
    var scoreName: String
    var scoreValue: String
}

struct SchoolDetailsContact {
    var contactName: String
    var contactValue: String
    var contactType: SchoolDetailsContactType 
}
