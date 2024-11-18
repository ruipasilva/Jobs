//
//  MockDependencyContainer.swift
//  JobsTests
//
//  Created by Rui Silva on 17/11/2024.
//

import Foundation
import Factory
@testable import Jobs

class MockDependencyContainer {
    static func setup() {
        let container = Container.shared.networkManager
        container.register { NetworkManagerMock() }
    }
}
