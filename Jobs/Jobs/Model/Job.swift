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
    var jobApplicationStatus: JobApplicationStatus = JobApplicationStatus.notApplied
    var jobApplicationStatusPrivate: String = ""
    var salary: String = ""
    var location: String = ""
    var locationType: LocationType = LocationType.onSite
    var recruiterName: String = ""
    var recruiterNumber: String = ""
    var recruiterEmail: String = ""
    var followUp: Bool = false
    var followUpDate: Date = Date.now
    var addToCalendar: Bool = false
    var addToCalendarDate: Date = Date.now
    var isEventAllDay: Bool = false
    var jobURLPosting: String = ""
    var logoURL: String = ""
    
    init(title: String,
         company: String,
         dateAdded: Date = Date.now,
         notes: String,
         jobApplicationStatus: JobApplicationStatus = .notApplied,
         jobApplicationStatusPrivate: String,
         salary: String,
         location: String,
         locationType: LocationType = .onSite,
         recruiterName: String,
         recruiterNumber: String,
         recruiterEmail: String,
         followUp: Bool,
         followUpDate: Date = Date.now,
         addToCalendar: Bool,
         addToCalendarDate: Date = Date.now,
         isEventAllDay: Bool,
         jobURLPosting: String,
         logoURL: String) {
             self.title = title
             self.company = company
             self.dateAdded = dateAdded
             self.notes = notes
             self.jobApplicationStatusPrivate = jobApplicationStatusPrivate
             self.jobApplicationStatus = jobApplicationStatus
             self.salary = salary
             self.location = location
             self.locationType = locationType
             self.recruiterName = recruiterName
             self.recruiterNumber = recruiterNumber
             self.recruiterEmail = recruiterEmail
             self.followUp = followUp
             self.followUpDate = followUpDate
             self.addToCalendar = addToCalendar
             self.addToCalendarDate = addToCalendarDate
             self.isEventAllDay = isEventAllDay
             self.jobURLPosting = jobURLPosting
        self.logoURL = logoURL
         }
    
    var icon: Image {
        switch jobApplicationStatus {
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
        switch jobApplicationStatus {
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

