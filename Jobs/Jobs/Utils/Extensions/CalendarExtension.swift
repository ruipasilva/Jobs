//
//  CalendarExtension.swift
//  Jobs
//
//  Created by Rui Silva on 19/02/2025.
//

import Foundation


extension Calendar {
    typealias WeekBoundary = (startOfWeek: Date?, endOfWeek: Date?)
    
    func currentWeekBoundary() -> WeekBoundary? {
        return weekBoundary(for: Date())
    }
    
    func weekBoundary(for date: Date = Date()) -> WeekBoundary? {
        guard let weekInterval = Self.autoupdatingCurrent.dateInterval(
                of: .weekOfYear, for: date) else { return nil }

        return (weekInterval.start, weekInterval.end)
    }
}
