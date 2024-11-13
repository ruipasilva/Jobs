//
//  MainViewViewModelTests.swift
//  JobsTests
//
//  Created by Rui Silva on 12/11/2024.
//

import XCTest
import SwiftData
@testable import Jobs

final class MainViewViewModelTests: XCTestCase {
    
    private let sut = MainViewViewModel()
    
    private let testJob = Job(title: "Title",
                              company: "Company",
                              notes: "Notes",
                              jobApplicationStatus: .notApplied,
                              jobApplicationStatusPrivate: "Status",
                              salary: "Salary",
                              location: "Location",
                              recruiterName: "RecruiterName",
                              recruiterNumber: "RecruiterNumber",
                              recruiterEmail: "RecruiterEmail",
                              followUp: false,
                              addToCalendar: false,
                              isEventAllDay: false,
                              jobURLPosting: "URL", 
                              logoURL: "LogoURL",
                              companyWebsite: "CompanyURL",
                              workingDays: [],
                              currencyType: .Euro)
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws { }
    
    // Since we are using @Query to fetch results, we will initialize a new ModelContainer
    @MainActor func test_JobsArrayIsEmpty_WhenContainerIsInitialized() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Job.self, configurations: configuration)
        
        let context = container.mainContext

        XCTAssertEqual(context.insertedModelsArray.count, 0)
    }
    
    func test_AcendingOrder_WhenTappedForward() throws {
        let expectedSortOrder: SortOrder = .forward
        
        sut.sortAscendingOrDescending(order: expectedSortOrder)
        
        XCTAssertEqual(sut.ascendingDescending, expectedSortOrder)
    }
    
    func test_AcendingOrder_WhenTappedReverse() throws {
        let expectedSortOrder: SortOrder = .reverse
        
        sut.sortAscendingOrDescending(order: expectedSortOrder)
        
        XCTAssertEqual(sut.ascendingDescending, expectedSortOrder)
    }
    
    func test_isSHowingnoewJobSheet_WhenButtonTapped() throws {
        
        sut.showNewJobSheet()
        
        XCTAssertTrue(sut.isShowingNewJob)
    }
    
    func test_ApplicationStatus_WhenTapped() throws {
        
        sut.setApplicationStatus(job: testJob, status: .applied)
        
        XCTAssertEqual(testJob.jobApplicationStatus, .applied)
    }
    
}
