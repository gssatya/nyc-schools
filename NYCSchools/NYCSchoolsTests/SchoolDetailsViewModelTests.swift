//
//  SchoolDetailsViewModelTest.swift
//  NYCSchoolsTests
//
//  Created by Satya Surya on 12/26/22.
//

import XCTest
import app_common
@testable import NYCSchools

class SchoolDetailsViewModelTests: XCTestCase {
    
    var viewModel = SchoolDetailsViewModel()
    var selectedSchool = NYCSchoolDataModel(dbn: "02M260", schoolName: "Clinton School Writers & Artists, M.S. 260",
                                            overviewParagraph: "", location: "", phoneNumber: "000-000-0000",
                                            schoolEmail: "asd@asd.com", website: "xyz.com")
    override func setUp() {
        NetworkManager.isRunningTests = true
    }
    
    func testGetData() {
        viewModel.setupData(with: ["SelectedSchool": selectedSchool])
        var expection = expectation(description: "Getting SAT results data")
        viewModel.getSchoolSATResults { _ in
            expection.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssert(viewModel.tableData.keys.count == 3)
        let contactArray = viewModel.tableData[SchoolDetailsTableSection.contact.rawValue] as? [SchoolDetailsContact]
        XCTAssertNotNil(contactArray)
        XCTAssertTrue(contactArray?.count == 4)
    }
}
