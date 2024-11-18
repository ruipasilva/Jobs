//
//  EditJobViewModel.swift
//  JobsTests
//
//  Created by Rui Silva on 15/11/2024.
//

import XCTest
@testable import Jobs

final class EditJobViewModelTests: XCTestCase {

    typealias Mocks = JobMock
    
    var sut: EditJobViewModel!

    
    override func setUp() {
        sut = EditJobViewModel(job: Mocks.mockJob)
    }
    
    func test_WhenLocationIsRemote_ThenReturnsTrue() {
        sut.locationType = .remote
        
        XCTAssertTrue(sut.isLocationRemote())
    }
    
    func test_WhenLocationIsOnSite_ThenReturnsFalse() {
        sut.locationType = .onSite
        
        XCTAssertFalse(sut.isLocationRemote())
    }
    
    func test_WhenLocationIsHybrid_ThenReturnsFalse() {
        sut.locationType = .hybrid
        
        XCTAssertFalse(sut.isLocationRemote())
    }
    
    func testUpdateProperties() {
        sut.updateJob()
        
        XCTAssertEqual(sut.job, Mocks.mockJob)
    }
    
    func testSetProperties() {
        sut.setProperties()
        
        XCTAssertEqual(sut.job, Mocks.mockJob)
    }
    
    func testLogoViewModelIsNotNil_WhenViewModelIsInitialised() {
        let logoOptionsViewModel = sut.getLogoOptionsViewModel()
        
        XCTAssertNotNil(logoOptionsViewModel)
    }
}
