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

    private var networkManagerMock: NetworkManaging!
    private var sut = NewJobViewModel()

    override func setUp() {
        super.setUp()
        
        sut = NewJobViewModel()

    }

    @MainActor func test_WhenSaveJob_ThenSaveJobToContext() throws {
        let configuration = ModelConfiguration()
        let container = try ModelContainer(
            for: Job.self, configurations: configuration)
        let context = container.mainContext

        sut.saveJob(context: context)

        XCTAssertEqual(context.insertedModelsArray.count, 1)
    }

    // TODO: Look into Mock URLProtocol
    func test_WhenGettingLogo_ThenReturnLogos() async throws {
        let expectedURL = "https://logo.clearbit.com/apple.com"
        let expectation = XCTestExpectation(description: "response")
        
        try await sut.getLogo(company: "Apple")
        
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 3)
        
        XCTAssertNotNil(sut.logoURL)
        XCTAssertEqual(sut.logoURL, expectedURL)
    }

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

}
