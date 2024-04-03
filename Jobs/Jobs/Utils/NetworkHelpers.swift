//
//  NetworkHelpers.swift
//  Jobs
//
//  Created by Rui Silva on 03/04/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case unableToComplete
    
    public var title: String{
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .invalidData:
            "Invalid Data"
        case .invalidResponse:
            "Invalid Response"
        case .unableToComplete:
            "Unable to complete"
        }
    }
}
