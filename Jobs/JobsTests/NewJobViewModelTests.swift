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

    override func tearDown() {
        sut = nil
        networkManagerMock = nil
        super.tearDown()
    }

}

class TestDependencyContainer {
    static func setup() {
        let container = Container.shared.networkManager
        container.register { NetworkManagerMock() }
    }
}
