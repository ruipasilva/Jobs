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

    private var networkManagerMock: NetworkManagerMock!

    override func setUp() {
        super.setUp()

        TestDependencyContainer.setup()

        networkManagerMock =
            Container.shared.networkManager() as? NetworkManagerMock
    }

    func test_whenRequestIsMade_ThenReturnLogos() async throws {
        networkManagerMock.shouldReturnError = false
        networkManagerMock.logos = [CompanyInfo(name: "Name", domain: "Domain", logo: "logoURL")]

        let logos = try await networkManagerMock.fetchData(query: "TestQuery")

        XCTAssertNotNil(logos)
        XCTAssertEqual(logos.first?.name, "Name")
    }

    func test_whenRequestIsMade_ThenReturnsInvalidResponse() async throws {
        networkManagerMock.shouldReturnError = true

        do {
            let _ = try await networkManagerMock.fetchData(query: "TestQuery")
        } catch {
            XCTAssertEqual(error as! NetworkError, NetworkError.invalidResponse)
        }
    }
    
    func test_whenRequestIsMade_ThenReturnsInvalidData() async throws {
        networkManagerMock.shouldReturnError = false
        networkManagerMock.logos = []

        do {
            let _ = try await networkManagerMock.fetchData(query: "TestQuery")
        } catch {
            XCTAssertEqual(error as! NetworkError, NetworkError.invalidData)
        }
    }

    override func tearDown() {
        networkManagerMock = nil
        super.tearDown()
    }

}
