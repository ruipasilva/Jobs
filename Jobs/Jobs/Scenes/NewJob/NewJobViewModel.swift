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
    
    public func showDiscardDialog() {
        showingCancelActionSheet = true
    }
    
    public func isTitleOrCompanyEmpty() -> Bool {
        return title.isEmpty || company.isEmpty
    }
    
    private func addNewJob(context: ModelContext) {
        let newJob = Job(localNotificationID: self.localNotificationID,
                         title: title,
                         company: company,
                         dateAdded: Date(),
                         notes: notes,
                         jobApplicationStatus: jobApplicationStatus,
                         jobApplicationStatusPrivate: jobApplicationStatus.status,
                         appliedDate: jobApplicationStatus == .notApplied ? nil : Date(),
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
                         jobURLPosting: jobURLPosting,
                         logoURL:  logoURL,
                         companyWebsite: companyWebsite,
                         workingDays: workingDays,
                         currencyType: currencyType)
        context.insert(newJob)
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
        do {
            try context.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
    
}
