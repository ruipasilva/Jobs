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

public final class NewJobViewModel: ObservableObject {
    @Published public var title = ""
    @Published public var company = ""
    @Published public var jobApplicationStatus = JobApplicationStatus.notApplied
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
    
    @Published public var showingCancelActionSheet = false
    
    public func isTitleOrCompanyEmpty(title: String, company: String) -> Bool {
        return title.isEmpty || company.isEmpty
    }
    
    @MainActor
    public func addNewJob(context: ModelContext) {
        let newJob = Job(title: title,
                         company: company,
                         notes: notes,
                         jobApplicationStatus: jobApplicationStatus,
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
                         jobURLPosting: url)
        context.insert(newJob)
    }
}

// MARK: Calendar helpers

extension NewJobViewModel {
    public func requestAuthCalendar(addInterviewToCalendar: Bool) async {
        if addInterviewToCalendar {
            let eventStore = EKEventStore()
            do {
                guard try await eventStore.requestWriteOnlyAccessToEvents() else { return }
            } catch {
                print("Something went wrong when allowing access to the calendar")
            }
        }
    }

    private func addReminderToCalendar(eventAllDay: Bool, company: String, title: String, addToCalendarDate: Date) {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = "Interview with \(company)"
        event.startDate = addToCalendarDate
        event.endDate = addToCalendarDate + TimeInterval(1800)
        event.notes = title
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.isAllDay = eventAllDay

        do {
            try eventStore.save(event, span: .thisEvent)
        } catch let error as NSError {
            print("failed to save event with error : \(error)")
        }
    }
    
    public func scheduleCalendarEvent(addEventToCalendar: Bool, eventAllDay: Bool, company: String, title: String, addToCalendarDate: Date) {
        if addEventToCalendar {
            addReminderToCalendar(eventAllDay: eventAllDay, company: company, title: title, addToCalendarDate: addToCalendarDate)
        }
    }
}

// MARK: Notifications helpers

extension NewJobViewModel {
    
    public func scheduleNotification(followUp: Bool, company: String, title: String, followUpDate: Date) {
        if followUp {
            scheduleNotification(company: company, title: title, followUpDate: followUpDate)
        }
    }
    
    public func requestAuthNotifications(followUp: Bool) {
        if followUp {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
                if success {
                    print("All Set For Notifications")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func scheduleNotification(company: String, title: String, followUpDate: Date) {
        let content = UNMutableNotificationContent()

        content.title = "Jobs: \(title) at \(company)"
        content.body = "Have you followed up on your job application?"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: followUpDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}