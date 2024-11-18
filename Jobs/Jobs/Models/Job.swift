//
//  Job.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI
import SwiftData

@Model
public final class InterviewQuestion: Hashable {
    var completed: Bool = false
    var question: String = ""
    var dateAdded: Date = Date.now
    
    var job: Job?
    
    init(completed: Bool,
         question: String,
         dateAdded: Date) {
        self.completed = completed
        self.question = question
        self.dateAdded = dateAdded
    }
}

@Model
public final class Job {
    // All properties need a default value as cloudKit needs it
    var localNotificationID: String?
    var title: String = ""
    var company: String = ""
    var dateAdded: Date = Date.now
    var notes: String = ""
    var jobApplicationStatus: JobApplicationStatus = JobApplicationStatus.notApplied
    var jobApplicationStatusPrivate: String = "" // Used to sort order
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
    // .cascade deletes all the related models
    @Relationship(deleteRule: .cascade, inverse: \InterviewQuestion.job) var interviewQuestions: [InterviewQuestion]?
    var workingDays: [String] = []
    var currencyType: CurrencyType = CurrencyType.dolar
    
    init(localNotificationID: String? = nil,
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
         interviewQuestions: [InterviewQuestion]? = nil,
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
        self.interviewQuestions = interviewQuestions
        self.workingDays = workingDays
        self.currencyType = currencyType
    }
}

