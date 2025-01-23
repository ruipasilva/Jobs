//
//  BaseViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 13/01/2025.
//

import Foundation

public class BaseViewModel: ObservableObject {
    @Published public var localNotificationID = ""
    @Published public var title = ""
    @Published public var company = ""
    @Published public var applicationStatusPrivate = ""
    @Published public var jobApplicationStatus = JobApplicationStatus.notApplied
    @Published public var jobApplicationStatusPrivate = ""
    @Published public var location = ""
    @Published public var locationType = LocationType.remote
    @Published public var salary = ""
    @Published public var followUp = false
    @Published public var followUpDate = Date.distantPast
    @Published public var addInterviewToCalendar = false
    @Published public var addInterviewToCalendarDate = Date.distantPast
    @Published public var isEventAllDay = false
    @Published public var recruiterName = ""
    @Published public var recruiterEmail = ""
    @Published public var recruiterNumber = ""
    @Published public var url = ""
    @Published public var notes = ""
    @Published public var logoURL = ""
    @Published public var companyWebsite = ""
    @Published public var interviewQuestions: [InterviewQuestion] = []
    @Published public var workingDaysToSave: [String] = []
    @Published public var currencyType: CurrencyType = .dolar
    
    public let workingDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    @Published public var showingCancelActionSheet = false
    
    public init() {}
}
