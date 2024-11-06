//
//  NewJobViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 02/04/2024.
//

import Foundation
import UserNotifications
import EventKit
import SwiftData
import SwiftUI

public final class NewJobViewModel: ObservableObject {
    @Published public var title = ""
    @Published public var company = ""
    @Published public var jobApplicationStatus = JobApplicationStatus.notApplied
    @Published public var jobApplicationStatusPrivate = ""
    @Published public var location: String = ""
    @Published public var locationType = LocationType.remote
    @Published public var salary = ""
    @Published public var followUp = false
    @Published public var followUpDate = Date.now
    @Published public var addInterviewToCalendar = false
    @Published public var addInterviewToCalendarDate = Date.now
    @Published public var isEventAllDay = false
    @Published public var recruiterName = ""
    @Published public var recruiterEmail = ""
    @Published public var recruiterNumber = ""
    @Published public var url = ""
    @Published public var notes = ""
    @Published public var logoURL = ""
    @Published public var companyWebsite = ""
    @Published public var interviewQuestion: [InterviewQuestion] = []
    @Published public var workingDaysToSave: [String] = []
    @Published public var currentyType: CurrencyType = CurrencyType.dolar
    
    @Published public var showingCancelActionSheet = false
    
    public let workingDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri",]
    
    private let networkManager: NetworkManaging
    public let calendarManager: CalendarManaging
    public let notificationManager: NotificationManaging
    
    public init(networkManager: NetworkManaging,
                calendarManager: CalendarManaging,
                notificationManager: NotificationManaging) {
        self.networkManager = networkManager
        self.calendarManager = calendarManager
        self.notificationManager = notificationManager
    }

    public func isTitleOrCompanyEmpty() -> Bool {
        return title.isEmpty || company.isEmpty
    }
    
    public func isLocationRemote() -> Bool {
        return locationType == .remote
    }
    
    public func showDiscardDialog() {
       showingCancelActionSheet = true
    }
    
    @MainActor
    public func getLogo(company: String) async {
        do {
            let logo = try await networkManager.fetchData(query: company)
            
            self.logoURL = logo.first?.logo ?? ""
            self.companyWebsite = logo.first?.domain ?? ""
    
        } catch {
            print(error.localizedDescription)
        }
    }
 
    private func addNewJob(context: ModelContext) {
        let newJob = Job(title: title,
                         company: company,
                         notes: notes,
                         jobApplicationStatus: jobApplicationStatus,
                         jobApplicationStatusPrivate: jobApplicationStatus.status,
                         salary: salary,
                         location: location,
                         locationType: locationType,
                         recruiterName: recruiterName,
                         recruiterNumber: recruiterNumber,
                         recruiterEmail: recruiterEmail,
                         followUp: followUp,
                         followUpDate: followUpDate,
                         addToCalendar: addInterviewToCalendar,
                         addToCalendarDate: addInterviewToCalendarDate,
                         isEventAllDay: isEventAllDay,
                         jobURLPosting: url,
                         logoURL: logoURL,
                         companyWebsite: companyWebsite,
                         workingDays: workingDaysToSave,
                         currencyType: currentyType
        )
        context.insert(newJob)
        newJob.interviewQuestions = interviewQuestion
    }
    
    public func saveJob(context: ModelContext) {
        addNewJob(context: context)
        
        notificationManager.scheduleNotification(followUp: followUp,
                             company: company,
                             title: title,
                             followUpDate: followUpDate)
        
        calendarManager.scheduleCalendarEvent(addEventToCalendar: addInterviewToCalendar,
                              eventAllDay: isEventAllDay,
                              company: company,
                              title: title,
                              addToCalendarDate: addInterviewToCalendarDate)
    }
    
    enum FocusedField {
        case companyName
        case jobTitle
        case recruiterName
        case recruiterEmail
        case recruiterNumber
        case url
        case notes
    }
}
