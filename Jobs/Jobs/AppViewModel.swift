//
//  AppViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Foundation
import SwiftData
import UserNotifications
import EventKit

public final class AppViewModel: ObservableObject {
    @Published public var isShowingNewJob = false
    @Published public var isNewJobExpanded = false
    @Published public var sortOrder = SortOrder.company
    @Published public var filter = ""
}

// MARK: Calendar helpers

extension AppViewModel {
    func requestAuthCalendar() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { _, _ in
        }
    }

    func addReminderToCalendar(eventAllDay: Bool, company: String, title: String, addToCalendarDate: Date) {
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
}

// MARK: Notifications helpers

extension AppViewModel {
    public func requestAuthNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("All Set For Notifications")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleNotification(company: String, title: String, followUpDate: Date) {
        let content = UNMutableNotificationContent()

        content.title = "Job Tracker: \(title) at \(company)"
        content.body = "Have you followed up on your job application?"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: followUpDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
