//
//  NetworkServiceTests.swift
//  JobsTests
//
//  Created by Rui Silva on 13/11/2024.
//

import Factory
import XCTest

@testable import Jobs

final class NetworkServiceTests: XCTestCase {
    typealias Mocks = JobMock

    private var networkManagerMock: NetworkManagerMock!

    override func setUp() {
        super.setUp()

        MockDependencyContainer.setup()

        networkManagerMock = Container.shared.networkManager() as? NetworkManagerMock
    }

    func test_whenRequestIsMade_ThenReturnLogos() async throws {
        networkManagerMock.shouldReturnError = false
        networkManagerMock.logos = Mocks.mockCompanyInfo

        let logos = try await networkManagerMock.fetchLogos(query: "TestQuery")

        XCTAssertNotNil(logos)
        XCTAssertEqual(logos.first?.domain, "Domain")
    }

    func test_whenRequestIsMade_ThenReturnsInvalidResponse() async throws {
        networkManagerMock.shouldReturnError = true

        do {
            let _ = try await networkManagerMock.fetchLogos(query: "TestQuery")
        } catch {
            XCTAssertEqual(error as! NetworkError, NetworkError.invalidResponse)
        }
    }
    
    func test_whenRequestIsMade_ThenReturnsInvalidData() async throws {
        networkManagerMock.shouldReturnError = false
        networkManagerMock.logos = []

        do {
            let _ = try await networkManagerMock.fetchLogos(query: "TestQuery")
        } catch {
            XCTAssertEqual(error as! NetworkError, NetworkError.invalidData)
        }
    }

    override func tearDown() {
        networkManagerMock = nil
        super.tearDown()
    }

}
