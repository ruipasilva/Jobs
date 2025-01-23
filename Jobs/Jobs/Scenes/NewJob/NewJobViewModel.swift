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

public final class NewJobViewModel: BaseViewModel {
    
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
    
    private func addNewJob(context: ModelContext) {
        let newJob = Job(localNotificationID: self.localNotificationID,
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
                         currencyType: currencyType)
        context.insert(newJob)
        newJob.interviewQuestions = interviewQuestions
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
