//
//  SchoolsListViewModel.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

class SchoolsListViewModel {
    
    var nycSchools: [NYCSchoolDataModel] = []
    
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
}
