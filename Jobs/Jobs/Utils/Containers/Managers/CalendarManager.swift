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
    func addReminderToCalendar(eventAllDay: Bool,
                               company: String,
                               title: String,
                               addToCalendarDate: Date,
                               localIdentifier: inout String)
    func scheduleCalendarEvent(addEventToCalendar: Bool,
                               eventAllDay: Bool,
                               company: String,
                               title: String,
                               addToCalendarDate: Date,
                               localIdentifier: inout String)
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
    
    public func addReminderToCalendar(eventAllDay: Bool, company: String, title: String, addToCalendarDate: Date, localIdentifier: inout String) {
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
            localIdentifier = event.eventIdentifier
        } catch let error as NSError {
            print("failed to save event with error : \(error)")
        }
    }
    
    public func scheduleCalendarEvent(addEventToCalendar: Bool, eventAllDay: Bool, company: String, title: String, addToCalendarDate: Date, localIdentifier: inout String) {
        if addEventToCalendar {
            addReminderToCalendar(eventAllDay: eventAllDay, company: company, title: title, addToCalendarDate: addToCalendarDate, localIdentifier: &localIdentifier)
        }
    }
    
    public func deleteEventById(eventID: String) async {
        let eventStore = EKEventStore()
        if let eventToDelete = eventStore.event(withIdentifier: eventID) {
            do {
                try eventStore.remove(eventToDelete, span: .thisEvent)
            } catch {
                print("Error deleting event: \(error.localizedDescription)")
            }
        }
    }
}
