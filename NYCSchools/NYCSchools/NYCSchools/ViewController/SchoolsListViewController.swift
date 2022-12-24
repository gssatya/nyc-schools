//
//  SchoolsListViewController.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import UIKit
import app_common

class SchoolsListViewController: UIViewController {
    
    var viewModel = SchoolsListViewModel()
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSchoolsData()
    }
    
    private func setupUI() {
        addNavigationBar()
        sortButton.layer.borderWidth = 0.2
        sortButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func getSchoolsData() {
        activityLoader.startAnimating()
        viewModel.getData { [weak self] success in
            DispatchQueue.main.async {
                self?.activityLoader.stopAnimating()
                if success {
                    self?.tableView.reloadData()
                } else {
                    self?.showAlert(style: .alert,
                                    title: "Data unavailable",
                                    message: "We're sorry, we couldn't retrieve the schools information right now. Please try again later.",
                                    cancelButtonTitle: "Ok")
                }
            }
        }
    }
    
    @IBAction func sort(_ sender: Any) {
        var actions: [UIAlertAction] = []
        for item in SchoolsSortingType.allCases {
            let title = item.rawValue.capitalized
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.viewModel.sortTableData(by: item)
                self?.tableView.reloadData()
            }
            actions.append(action)
        }
        
        showAlert(style: .actionSheet,
                  title: "Sort by",
                  cancelButtonTitle: "Cancel",
                  otherButtons: actions,
                  sourceView: sortButton)
    }
}

// MARK: Table view delegate methods

extension SchoolsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.tableData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SchoolsListTableViewCell.identifier) as? SchoolsListTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = item.schoolName ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: Search Bar protocol

extension SchoolsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterTableData(for: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: Navigation Bar Protocol

extension SchoolsListViewController: NavigationBarProtocol {
    func getNavigationBar() -> NavigationBarItem {
        return NavigationBarItem(shouldHide: false, title: "NYC Schools")
    }
}
