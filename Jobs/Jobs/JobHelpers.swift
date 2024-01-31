//
//  JobHelpers.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Foundation

public enum JobApplicationStatus: Int, Codable, Identifiable, CaseIterable {
    case notApplied, applied, interviewing, accepted, rejected
    
    public var id: Self {
        self
    }
    
    var status: String {
        switch self {
        case .notApplied:
            "Not applied"
        case .applied:
            "Applied"
        case .interviewing:
            "Interviewing"
        case .accepted:
            "Hired"
        case .rejected:
            "Rejected"
        }
    }
}

public enum LocationType: Int, Codable, Identifiable, CaseIterable {
    case onSite, remote, hybrid
    
    public var id: Self { self }
    
    var type: String {
        switch self {
        case .onSite:
            "On Site"
        case .remote:
            "Remote"
        case .hybrid:
            "Hybrid"
        }
    }
}

public enum SortOrder: String, Identifiable, CaseIterable {
    case status, title, company
    
    public var id: Self {
        self
    }
    
    var status: String {
        switch self {
        case .title:
            "Title"
        case .company:
            "Company"
        case .status:
            "Status"
        }
    }
    
}
