//
//  SchoolDetailsViewController.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/25/22.
//

import Foundation
import UIKit
import app_common
import CoreLocation

class SchoolDetailsViewController: UIViewController, NavigationPayloadProtocol {
    
    var payload: [String : Any]? {
        didSet {
            viewModel.setupData(with: payload)
        }
    }
    var viewModel = SchoolDetailsViewModel()
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    /// Method to fetch data 
    private func getData() {
        activityLoader.startAnimating()
        viewModel.getSchoolSATResults { [weak self] success in
            self?.activityLoader.stopAnimating()
            if success {
                self?.tableView.reloadData()
            } else {
                self?.showAlert(style: .alert,
                                title: "Data unavailable",
                                message: "We're sorry, we couldn't retrieve the SAT Results for the selected school. Please try a different school.",
                                cancelButtonTitle: "Ok")
            }
        }
    }

}

// MARK: Table view delegate methods

extension SchoolDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableData.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            guard let satArray = viewModel.tableData[SchoolDetailsTableSection.satScores.rawValue] as? [SchoolDetailsSATScores] else {
                return 0
            }
            return satArray.count
        case 2:
            guard let contactArray = viewModel.tableData[SchoolDetailsTableSection.contact.rawValue] as? [SchoolDetailsContact] else {
                return 0
            }
            return contactArray.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        
        case 0:
            guard let overviewData = viewModel.tableData[SchoolDetailsTableSection.overview.rawValue] as? SchoolDetailsOverview,
                    let cell = tableView.dequeueReusableCell(withIdentifier: SchoolDetailsOverviewTableViewCell.identifier) as? SchoolDetailsOverviewTableViewCell else {
                return UITableViewCell()
            }
            cell.nameLabel.text = overviewData.schoolName
            cell.overviewLabel.text = overviewData.overview
            cell.selectionStyle = .none
            return cell
        
        case 1:
            guard let satScoreArray = viewModel.tableData[SchoolDetailsTableSection.satScores.rawValue] as? [SchoolDetailsSATScores],
                    let cell = tableView.dequeueReusableCell(withIdentifier: SchoolDetailsTableViewCell.identifier) as? SchoolDetailsTableViewCell else {
                return UITableViewCell()
            }
            let item = satScoreArray[indexPath.row]
            cell.keyLabel.text = item.scoreName
            cell.valueLabel.text = item.scoreValue
            cell.selectionStyle = .none
            return cell
        
        case 2:
            guard let contactArray = viewModel.tableData[SchoolDetailsTableSection.contact.rawValue] as? [SchoolDetailsContact],
                    let cell = tableView.dequeueReusableCell(withIdentifier: SchoolDetailsTableViewCell.identifier) as? SchoolDetailsTableViewCell else {
                return UITableViewCell()
            }
            let item = contactArray[indexPath.row]
            cell.keyLabel.text = item.contactName
            cell.valueLabel.text = item.contactValue
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        switch section {
        case 0: return nil
        case 1: title = "SAT SCORES"
        case 2: title = "CONTACT"
        default: return nil
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SchoolDetailsSectionHeaderView.identifier) as? SchoolDetailsSectionHeaderView else {
            return nil
        }
        cell.titleLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.section == 2,
              let contactArray = viewModel.tableData[SchoolDetailsTableSection.contact.rawValue] as? [SchoolDetailsContact] else {
            return
        }
        let item = contactArray[indexPath.row]
        switch item.contactType {
        case .location:
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(item.contactValue) { (placemarks, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let location = placemarks?.first?.location {
                        let query = "?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
                        let urlString = "http://maps.apple.com/".appending(query)
                        if let url = URL(string: urlString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        case .phone:
            guard let number = URL(string: "tel://" + item.contactValue) else { return }
            UIApplication.shared.open(number)
        case .email:
            guard let email = URL(string: "mailto:" + item.contactValue) else { return }
            UIApplication.shared.open(email)
        case .website:
            guard let website = URL(string: "https://" + item.contactValue) else { return }
            UIApplication.shared.open(website)
        }
    }
}

// MARK: Navigation Bar Protocol

extension SchoolDetailsViewController: NavigationBarProtocol {
    func getNavigationBar() -> NavigationBarItem {
        return NavigationBarItem(shouldHide: false, title: "NYC Schools", leftButtons: [.back])
    }
}

