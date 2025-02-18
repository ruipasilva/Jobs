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
    // All properties need a default value as cloudKit requires it
    var localNotificationID: String?
    var title: String = ""
    var company: String = ""
    var dateAdded: Date = Date.now
    var notes: String = ""
    var jobApplicationStatus: JobApplicationStatus = JobApplicationStatus.notApplied
    var jobApplicationStatusPrivate: String = "" // Used to sort order and totals: SwiftData doesn't like enums used in the #predicates
    var appliedDate: Date?
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
    var companyWebsite: String = ""
    var workingDays: [String] = []
    var currencyType: CurrencyType = CurrencyType.dolar

    public init(localNotificationID: String? = nil,
         title: String,
         company: String,
         dateAdded: Date = Date.now,
         notes: String,
         jobApplicationStatus: JobApplicationStatus = .notApplied,
         jobApplicationStatusPrivate: String,
         appliedDate: Date? = nil,
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
         logoURL: String,
         companyWebsite: String,
         workingDays: [String],
         currencyType: CurrencyType) {
        self.localNotificationID = localNotificationID
        self.title = title
        self.company = company
        self.dateAdded = dateAdded
        self.notes = notes
        self.jobApplicationStatusPrivate = jobApplicationStatusPrivate
        self.jobApplicationStatus = jobApplicationStatus
        self.appliedDate = appliedDate
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
        self.companyWebsite = companyWebsite
        self.workingDays = workingDays
        self.currencyType = currencyType
    }
}
