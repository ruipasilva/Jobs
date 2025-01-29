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
    public var localNotificationID: String?
    public var title: String = ""
    public var company: String = ""
    public var dateAdded: Date = Date.now
    public var notes: String = ""
    public var jobApplicationStatus: JobApplicationStatus = JobApplicationStatus.notApplied
    public var jobApplicationStatusPrivate: String = "" // Used to sort order
    public var salary: String = ""
    public var location: String = ""
    public var locationType: LocationType = LocationType.onSite
    public var recruiterName: String = ""
    public var recruiterNumber: String = ""
    public var recruiterEmail: String = ""
    public var followUp: Bool = false
    public var followUpDate: Date = Date.now
    public var addToCalendar: Bool = false
    public var addToCalendarDate: Date = Date.now
    public var isEventAllDay: Bool = false
    public var jobURLPosting: String = ""
    public var logoURL: String = ""
    public var companyWebsite: String = ""
    public var workingDays: [String] = []
    public var currencyType: CurrencyType = CurrencyType.dolar

    public init(localNotificationID: String? = nil,
         title: String,
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
