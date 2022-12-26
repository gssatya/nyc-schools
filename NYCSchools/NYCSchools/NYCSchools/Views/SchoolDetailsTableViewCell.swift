//
//  SchoolDetailsTableViewCell.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/25/22.
//

import Foundation
import UIKit

/// Table view cell class for the School Details section header
class SchoolDetailsSectionHeaderView: UITableViewCell {
    static let identifier: String = "SchoolDetailsSectionHeaderView"
    @IBOutlet weak var titleLabel: UILabel!
}

/// Table view cell class for the School Details overview row
class SchoolDetailsOverviewTableViewCell: UITableViewCell {
    static let identifier: String = "SchoolDetailsOverviewTableViewCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
}

/// Table view cell class for the School Details table
class SchoolDetailsTableViewCell: UITableViewCell {
    static let identifier: String = "SchoolDetailsTableViewCell"
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}
