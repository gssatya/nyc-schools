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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSchoolsData()
    }
    
    private func setupUI() {
        addNavigationBar()
    }
    
    private func getSchoolsData() {
        viewModel.getData { [weak self] success in
            DispatchQueue.main.async {
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
}

// MARK: Table view delegate methods

extension SchoolsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nycSchools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.nycSchools[indexPath.row]
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
        viewModel?.filterTableData(for: searchText)
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
