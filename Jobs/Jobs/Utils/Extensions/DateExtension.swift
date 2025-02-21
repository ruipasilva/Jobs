//
//  DateExtension.swift
//  Jobs
//
//  Created by Rui Silva on 12/02/2025.
//

import Foundation

extension Date {
    func dayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    func weekdayName(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E" // "E" gives "Mon", "Tue", etc.
            return formatter.string(from: date)
        }
    
}
