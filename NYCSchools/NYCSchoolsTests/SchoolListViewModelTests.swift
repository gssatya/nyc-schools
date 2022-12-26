//
//  SchoolListViewModelTests.swift
//  NYCSchoolsTests
//
//  Created by Satya Surya on 12/25/22.
//

import XCTest
import app_common
@testable import NYCSchools

class SchoolListViewModelTests: XCTestCase {
    
    var viewModel = SchoolsListViewModel()
    
    override func setUp() {
        NetworkManager.isRunningTests = true
    }
    
    func testGetData() {
        let expectation = expectation(description: "Loading Schools list API")
        viewModel.getData { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertTrue(!viewModel.tableData.isEmpty)
    }
    
    func testFilterData() {
        let expectation = expectation(description: "Loading Schools list API")
        viewModel.getData { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
        viewModel.filterTableData(for: "Belmont")
        XCTAssertTrue(viewModel.tableData.count == 1)
        viewModel.filterTableData(for: "")
        XCTAssertTrue(viewModel.tableData.count == 440)
    }
    
    func testSortTableData() {
        let expectation = expectation(description: "Loading Schools list API")
        viewModel.getData { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
        viewModel.sortTableData(by: .name)
        XCTAssert(viewModel.tableData.first?.dbn == "06M540")
        viewModel.sortTableData(by: .safety)
        XCTAssert(viewModel.tableData.first?.dbn == "14K488")
    }
}
