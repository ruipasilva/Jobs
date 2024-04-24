//
//  JobHelpers.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Foundation

public enum JobApplicationStatus: String, Codable, Identifiable, CaseIterable, RawRepresentable {
    case notApplied, applied, interviewing, accepted, rejected
    
    public var id: Self { self }
    
    var status: String {
        switch self {
        case .notApplied:
            "Not Applied"
        case .applied:
            "Applied"
        case .interviewing:
            "Interviewing"
        case .accepted:
            "Accepted"
        case .rejected:
            "Rejected"
        }
    }
}

public enum LocationType: Codable, Identifiable, CaseIterable {
    case remote, onSite, hybrid
    
    public var id: Self { self }
    
    var type: String {
        switch self {
        case .remote:
            "Remote"
        case .onSite:
            "On Site"
        case .hybrid:
            "Hybrid"
        }
    }
}

public enum SortOrdering: Int, Identifiable, CaseIterable {
    
    /// Add case status when SwiftData allows sort by enums
    case title, company, salary, status
    
    public var id: Self {
        self
    }
    
    var status: String {
        switch self {
        case .title:
            "Title"
        case .company:
            "Company"
        case .salary:
            "Salary"
        case .status:
            "Status"
        }
    }
}
