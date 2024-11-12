//
//  MainViewViewModelTests.swift
//  JobsTests
//
//  Created by Rui Silva on 12/11/2024.
//

import XCTest
@testable import Jobs
import SwiftData

final class MainViewViewModelTests: XCTestCase {
    
    private let sut = MainViewViewModel()
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws { }
    
    @MainActor func test_JobsArrayIsEmpty_WhenContainerisInitialized() throws {
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
}
