//
//  SchoolsListViewModel.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

// MARK: - Enum for type of sorting

enum SchoolsSortingType: String, CaseIterable {
    case name = "Name"
    case strength = "Strength (low to high)"
    case safety = "Safety Score (low to high)"
}

// MARK: - View model class

class SchoolsListViewModel {
    
    private var nycSchools: [NYCSchoolDataModel] = [] {
        didSet {
            tableData = nycSchools
        }
    }
    var tableData: [NYCSchoolDataModel] = []
    
    /// Method to get the data from API
    /// - Parameter completion: Bool with success or failure.
    func getData(completion: @escaping ((Bool) -> Void)) {
        let service = SchoolsListService()
        ApiNetworkClient.callService(with: service,
                                     allowOfflineLoad: true,
                                     responseType: [NYCSchoolDataModel].self) { [weak self] error, data in
            guard error == nil, let data = data else {
                completion(false)
                return
            }
            self?.nycSchools = data
            completion(true)
        }
    }
    
    /// Method to filter data based on search text.
    func filterTableData(for filterString: String) {
        if filterString.isEmpty {
            tableData = nycSchools
            return
        }
        
        let filteredTableData = nycSchools.filter {
            $0.schoolName?.range(of: filterString, options: .caseInsensitive) != nil
        }
        tableData = filteredTableData
    }
    
    /// Method to sort the schools list
    /// - Parameter sortType: Sort type.
    func sortTableData(by sortType: SchoolsSortingType) {
        var sortedData: [NYCSchoolDataModel] = []
        switch sortType {
        case .name:
            sortedData = tableData.sorted(by: { ($0.schoolName ?? "") < ($1.schoolName ?? "") })
        case .strength:
            sortedData = tableData.sorted(by: { Float($0.strength ?? "0") ?? 0 < Float($1.strength ?? "0") ?? 0 })
        case .safety:
            sortedData = tableData.sorted(by: { Float($0.safetyScore ?? "0") ?? 0 < Float($1.safetyScore ?? "0") ?? 0 })
        }
        tableData = sortedData
    }
}
