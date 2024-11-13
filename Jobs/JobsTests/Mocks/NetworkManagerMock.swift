//
//  NetworkManagerMock.swift
//  JobsTests
//
//  Created by Rui Silva on 13/11/2024.
//

import Foundation
@testable import Jobs

class NetworkManagerMock: NetworkManaging {
    var shouldReturnError = false
    var logos: [CompanyInfo]?
    
    func fetchData(query: String) async throws -> [CompanyInfo] {
        if shouldReturnError {
            throw NetworkError.invalidResponse
        } else if let logos = logos {
            return logos
        } else {
            throw NetworkError.invalidData
        }
    }
    
    
}

