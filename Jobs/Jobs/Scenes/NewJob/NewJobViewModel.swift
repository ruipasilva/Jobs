//
//  NewJobViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 02/04/2024.
//

import EventKit
import Factory
import Foundation
import SwiftData
import UserNotifications

public final class NewJobViewModel: ObservableObject {
    @Published public var localNotificationID = ""
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

    public let workingDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri"]

    @Injected(\.networkManager) private var networkManager
    @Injected(\.calendarManager) public var calendarManager
    @Injected(\.notificationManager) public var notificationManager

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

            guard let logoPrivate = logo.first?.logo, let domainPrivate = logo.first?.domain else { return }
            
            self.logoURL = logoPrivate
            self.companyWebsite = domainPrivate

        } catch {
            // Not actually handling error because if fails, it will show a default SFSymbol
            print(error.localizedDescription)
        }
    }

    private func addNewJob(context: ModelContext) {
        let newJob = Job(
            localNotificationID: self.localNotificationID,
            title: title,
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
        
        if followUp {
            notificationManager.scheduleNotification(
                company: company,
                title: title,
                followUpDate: followUpDate,
                id: &localNotificationID)
        }

        if addInterviewToCalendar {
            calendarManager.scheduleCalendarEvent(
                eventAllDay: isEventAllDay,
                company: company,
                title: title,
                addToCalendarDate: addInterviewToCalendarDate)
        }

        addNewJob(context: context)
    }
}
