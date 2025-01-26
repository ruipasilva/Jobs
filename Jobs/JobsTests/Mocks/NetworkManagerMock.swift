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
    var onlineJobs: Jobs.OnlineJobsResults?
    
    func fetchLogos(query: String) async throws -> [Jobs.CompanyInfo] {
        if shouldReturnError {
            throw NetworkError.invalidResponse
        } else if let logos = logos {
            return logos
        } else {
            throw NetworkError.invalidData
        }
    }
    
    func fetchOnlineJobs(query: String) async throws -> Jobs.OnlineJobsResults {
        if shouldReturnError {
            throw NetworkError.invalidResponse
        } else if let onlineJobs = onlineJobs {
            return onlineJobs
        } else {
            throw NetworkError.invalidData
        }
    }
}

