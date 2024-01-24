//
//  Job.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI
import SwiftData

@Model
public final class Job {
    var title: String
    var company: String
    var dateAdded: Date
    var notes: String
    var jobApplicationStatus: JobApplicationStatus.RawValue
    
    init(title: String,
        company: String,
        dateAdded: Date = Date.now,
         notes: String = "",
         jobApplicationStatus: JobApplicationStatus = .notApplied) {
        self.title = title
        self.company = company
        self.dateAdded = dateAdded
        self.notes = notes
        self.jobApplicationStatus = jobApplicationStatus.rawValue
    }
    
    var icon: Image {
        switch JobApplicationStatus(rawValue: jobApplicationStatus)! {
        case .notApplied:
            Image(systemName: "clock")
        case .applied:
            Image(systemName: "bookmark.circle")
        case .interviewing:
            Image(systemName: "person.circle")
        case .accepted:
            Image(systemName: "checkmark.circle")
        case .rejected:
            Image(systemName: "x.circle")
        }
    }
 
}

enum JobApplicationStatus: Int, Codable, Identifiable, CaseIterable {
    case notApplied, applied, interviewing, accepted, rejected
    
    var id: Self {
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
