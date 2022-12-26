//
//  SchoolsListTableViewCell.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation
import UIKit

/// Table view cell class for the Schools list
class SchoolsListTableViewCell: UITableViewCell {
    static let identifier: String = "SchoolsListTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        titleLabel.text = ""
        super.prepareForReuse()
    }
}
