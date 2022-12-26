//
//  SchoolDetailsViewModel.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/25/22.
//

import Foundation

class SchoolDetailsViewModel {
    
    private var selectedSchool: NYCSchoolDataModel?
    private var satResultsData: SATResultsDataModel?
    var tableData: [String: Any] = [:]
    
    func setupData(with payload: [String: Any]?) {
        guard let selectedSchool = payload?["SelectedSchool"] as? NYCSchoolDataModel else {
            return
        }
        self.selectedSchool = selectedSchool
    }
    
    func getNavBarTitle() -> String {
        return selectedSchool?.schoolName ?? ""
    }
    
    func getSchoolSATResults(completion: @escaping ((Bool) -> Void)) {
        guard let schoolId = selectedSchool?.dbn else {
            completion(false)
            return
        }
        let service = SATResultsService(with: schoolId)
        ApiNetworkClient.callService(with: service,
                                     allowOfflineLoad: true,
                                     responseType: [SATResultsDataModel].self) { [weak self] error, response in
            guard error == nil, let data = response, let result = data.first else {
                completion(false)
                return
            }
            self?.satResultsData = result
            self?.setupTableData()
            completion(true)
        }
    }
    
    func setupTableData() {
        guard let selectedSchool = selectedSchool, let satResultsData = satResultsData else {
            return
        }
        
        if let overview = selectedSchool.overviewParagraph {
            let overviewRow = SchoolDetailsOverview(schoolName: "", overview: overview)
            tableData[SchoolDetailsTableSection.overview.rawValue] = overviewRow
        }
        
        var satScoresArray: [SchoolDetailsSATScores] = []
        if let takers = satResultsData.testTakers {
            satScoresArray.append(SchoolDetailsSATScores(scoreName: "No. of Test Takers", scoreValue: takers))
        }
        if let reading = satResultsData.readingAvg {
            satScoresArray.append(SchoolDetailsSATScores(scoreName: "Avg. Reading Score", scoreValue: reading))
        }
        if let writing = satResultsData.writingAvg {
            satScoresArray.append(SchoolDetailsSATScores(scoreName: "Avg. Writing Score", scoreValue: writing))
        }
        if let math = satResultsData.mathAvg {
            satScoresArray.append(SchoolDetailsSATScores(scoreName: "Avg. Math Score", scoreValue: math))
        }
        tableData[SchoolDetailsTableSection.satScores.rawValue] = satScoresArray
        
        var contactArray: [SchoolDetailsContact] = []
        if let phone = selectedSchool.phoneNumber {
            contactArray.append(SchoolDetailsContact(contactName: "Phone", contactValue: phone, contactType: .phone))
        }
        if let email = selectedSchool.schoolEmail {
            contactArray.append(SchoolDetailsContact(contactName: "Email Address", contactValue: email, contactType: .email))
        }
        if let website = selectedSchool.website {
            contactArray.append(SchoolDetailsContact(contactName: "Website", contactValue: website, contactType: .website))
        }
        if let location = selectedSchool.location {
            contactArray.append(SchoolDetailsContact(contactName: "Location", contactValue: location, contactType: .location))
        }
        tableData[SchoolDetailsTableSection.contact.rawValue] = contactArray
    }
    
}
