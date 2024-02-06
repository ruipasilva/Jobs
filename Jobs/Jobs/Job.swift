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
    // All properties need a default value as cloudKit needs it
    var title: String = ""
    var company: String = ""
    var dateAdded: Date = Date.now
    var notes: String = ""
    var jobApplicationStatus: JobApplicationStatus.RawValue = JobApplicationStatus.notApplied.rawValue
    var salary: String?
    var location: String?
    var locationType: LocationType.RawValue = LocationType.onSite.rawValue
    var recruiterName: String?
    var recruiterNumber: String?
    var recruiterEmail: String?
    var interviewDate: Date?
    var addToCalendar: Bool = false
    var addToCalendarDate: Date?
    var jobURLPosting: String?
    
    init(title: String,
         company: String,
         dateAdded: Date = Date.now,
         notes: String = "",
         jobApplicationStatus: JobApplicationStatus = .notApplied,
         salary: String? = nil,
         location: String? = nil,
         locationType: LocationType = .onSite,
         recruiterName: String? = nil,
         recruiterNumber: String? = nil,
         recruiterEmail: String? = nil,
         interviewDate: Date = Date.distantFuture,
         addToCalendar: Bool = false,
         addToCalendarDate: Date = Date.now,
         jobURLPosting: String? = nil) {
        self.title = title
        self.company = company
        self.dateAdded = dateAdded
        self.notes = notes
        self.jobApplicationStatus = jobApplicationStatus.rawValue
        self.salary = salary
        self.location = location
        self.locationType = locationType.rawValue
        self.recruiterName = recruiterName
        self.recruiterNumber = recruiterNumber
        self.recruiterEmail = recruiterEmail
        self.interviewDate = interviewDate
        self.addToCalendar = addToCalendar
        self.addToCalendarDate = addToCalendarDate
        self.jobURLPosting = jobURLPosting
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
    
    var status: String {
        switch JobApplicationStatus(rawValue: jobApplicationStatus)! {
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

