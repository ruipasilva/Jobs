//
//  NewJobViewModel.swift
//  JobsTests
//
//  Created by Rui Silva on 13/11/2024.
//

import Factory
import SwiftData
import XCTest

@testable import Jobs

final class NewJobViewModelTests: XCTestCase {
    typealias Mocks = JobMock

    private var networkManagerMock: NetworkManagerMock!
    private var sut: NewJobViewModel!

    override func setUp() {
        super.setUp()

        TestDependencyContainer.setup()
        
        networkManagerMock = Container.shared.networkManager() as? NetworkManagerMock
        sut = NewJobViewModel()

    }

    @MainActor func test_WhenSaveJob_ThenSaveJobToContext() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Job.self, configurations: configuration)
        let context = container.mainContext

        sut.saveJob(context: context)

        XCTAssertEqual(context.insertedModelsArray.count, 1)
    }

//    func test_WhenGettingLogo_ThenReturnLogos() async throws {
//        networkManagerMock.shouldReturnError = false
//        networkManagerMock.logos = Mocks.mockCompanyInfo
//        
//        let expectation = XCTestExpectation(description: "response")
//        Task {
//            let _ = await sut.getLogo(company: "TestQuery")
//            expectation.fulfill()
//            await fulfillment(of: [expectation], timeout: 3)
//        }
//        
//        
//
//        
//        XCTAssertEqual(sut.logoURL, "LogoURL")
//
//    }

    override func tearDown() {
        sut = nil
        networkManagerMock = nil
        super.tearDown()
    }

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

}

class TestDependencyContainer {
    static func setup() {
        let container = Container.shared.networkManager
        container.register { NetworkManagerMock() }
    }
}
