//
//  CalendarHelpers.swift
//  Jobs
//
//  Created by Rui Silva on 06/11/2024.
//

import Foundation
import EventKit

public protocol CalendarManaging {
    func requestAuthCalendar(addInterviewToCalendar: Bool) async
    func addReminderToCalendar(eventAllDay: Bool, company: String, title: String, addToCalendarDate: Date)
    func scheduleCalendarEvent(addEventToCalendar: Bool, eventAllDay: Bool, company: String, title: String, addToCalendarDate: Date)
}

public struct CalendarManager: CalendarManaging {
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

    public func addReminderToCalendar(eventAllDay: Bool, company: String, title: String, addToCalendarDate: Date) {
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
