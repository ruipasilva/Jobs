//
//  Helpers.swift
//  
//
//  Created by Rui Silva on 22/01/2025.
//

import Foundation
import SwiftUI

public enum FocusedField {
    case companyName
    case jobTitle
    case companyWebsite
    case recruiterName
    case recruiterEmail
    case recruiterNumber
    case url
    case notes
    case location
}

public enum JobApplicationStatus: String, Codable, Identifiable, CaseIterable, RawRepresentable {
    case notApplied, applied, started, rejected, declined, offer

    public var id: Self { self }

    public var status: String {
        switch self {
        case .notApplied:
            "Shortlisted"
        case .applied:
            "Applied"
        case .started:
            "Started"
        case .rejected:
            "Rejected"
        case .declined:
            "Declined"
        case .offer:
            "Offer"
        }
    }
    
    public var icon: String {
        switch self {
        case .notApplied:
            "bookmark"
        case .applied:
            "checkmark"
        case .started:
            "arrow.right"
        case .rejected:
            "xmark"
        case .declined:
            "hand.thumbsdown"
        case .offer:
            "text.page"
        }
    }
    
    public var color: Color {
        switch self {
        case .notApplied:
                Color(uiColor: .systemGray)
        case .applied:
                .orange
        case .started:
                .indigo
        case .rejected, .declined:
                .red
        case .offer:
                .green
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

public enum WeekOrYear: String, Identifiable, CaseIterable {
    case week, year
    
    public var id: Self { self }
    
    var time: String {
        switch self {
        case .week:
            "Week"
        case .year:
            "Year"
        }
    }
}
