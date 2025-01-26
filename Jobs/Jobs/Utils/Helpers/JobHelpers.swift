//
//  Helpers.swift
//  
//
//  Created by Rui Silva on 22/01/2025.
//

import Foundation

public enum FocusedField {
    case companyName
    case jobTitle
    case companyWebsite
    case recruiterName
    case recruiterEmail
    case recruiterNumber
    case url
    case notes
}

public enum JobApplicationStatus: String, Codable, Identifiable, CaseIterable {
    case notApplied, applied, started, hired, rejected
    

    public var id: Self { self }

    public var status: String {
        switch self {
        case .notApplied:
            "Not Applied"
        case .applied:
            "Applied"
        case .started:
            "Started"
        case .hired:
            "Hired"
        case .rejected:
            "Rejected"
        }
    }
}

public enum LocationType: Codable, Identifiable, CaseIterable {
    case remote, onSite, hybrid

    public var id: Self { self }

    public var type: String {
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

public enum SortingOrder: Int, Identifiable, CaseIterable {

    /// Add case status when SwiftData allows sort by enums
    case title, company, salary, status, dateAdded

    public var id: Self {
        self
    }

    public var status: String {
        switch self {
        case .title:
            "Title"
        case .company:
            "Company"
        case .salary:
            "Salary"
        case .status:
            "Status"
        case .dateAdded:
            "Date Added"
        }
    }
}

public enum CurrencyType: String, Codable, Identifiable, CaseIterable {

    case libra, dolar, Euro, yen

    public var id: Self { self }

    public var symbol: String {
        switch self {
        case .libra:
            "£"
        case .dolar:
            "$"
        case .Euro:
            "€"
        case .yen:
            "¥"
        }
    }
}
