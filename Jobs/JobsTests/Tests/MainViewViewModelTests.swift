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
    typealias Mocks = JobMock
    
    private let sut = MainViewViewModel()
    
    
    // Since we are using @Query to fetch results, we will initialize a new ModelContainer
    @MainActor func test_JobsArrayIsEmpty_WhenAppStarts() throws {
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
        
        XCTAssertTrue(sut.isShowingNewJobView)
    }
    
    func test_ApplicationStatus_WhenTapped() throws {
        
        sut.setApplicationStatus(job: Mocks.mockJob, status: .applied)
        
        XCTAssertEqual(Mocks.mockJob.jobApplicationStatus, .applied)
    }
    
}
