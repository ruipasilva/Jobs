//
//  InsightsViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 06/07/2024.
//

import Foundation

public final class InsightsViewModel: ObservableObject {
    @Published public var weekOrMonth: WeekOrMonth = .week
    
    typealias DataInfo = (date: Date, count: Int)
    
    func getDateWithCurrentWeek() -> String {
        let calendarWeekBoundary = Calendar.current.currentWeekBoundary()
        let dayFormatter = DateFormatter()
        let monthFormatter = DateFormatter()
    
        dayFormatter.dateFormat = "d"
        monthFormatter.dateFormat = "MMM"
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        guard let startOfWeek = calendarWeekBoundary?.startOfWeek else {
            return dayFormatter.string(from: Date())
        }
        
        guard let endOfWeek = calendarWeekBoundary?.endOfWeek else {
            return dayFormatter.string(from: Date())
        }
        
        let combinedDateString = "\(monthFormatter.string(from: Date())) \(dayFormatter.string(from: startOfWeek))-\(dayFormatter.string(from: endOfWeek)), \(currentYear)"
        
        return combinedDateString
    }
    
    func jobsByWeekDay(jobs: [Job]) -> [DataInfo] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        var fullWeek = (0..<7).compactMap { dayOffset -> DataInfo in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)!
            return (date, 0)
        }
        
        let validJobs = jobs.compactMap { job -> (Date, Job)? in
            guard let applicationDate = job.appliedDate else { return nil }
            return (calendar.startOfDay(for: applicationDate), job)
        }
        
        let grouped = Dictionary(grouping: validJobs, by: {
            calendar.startOfDay(for: $0.0) })
        let jobCounts = grouped.mapValues { $0.count }
        
        for i in fullWeek.indices {
            let day = fullWeek[i].date
            if let count = jobCounts[day] {
                fullWeek[i] = (day, count)
            }
        }
        
        return fullWeek
    }
    
    func jobsByMonth(jobs: [Job]) -> [DataInfo] {
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            
        var fullYear = (1...12).compactMap { month -> DataInfo in
                let date = calendar.date(from: DateComponents(year: currentYear, month: month, day: 1))!
                return (date, 0)
            }
            
            let grouped = Dictionary(grouping: jobs, by: {
                calendar.date(from: calendar.dateComponents([.year, .month], from: $0.dateAdded))!
            })
            
            let jobCounts = grouped.mapValues { $0.count }
            
            for i in fullYear.indices {
                let month = fullYear[i].date
                if let count = jobCounts[month] {
                    fullYear[i] = (month, count)
                }
            }
            
            return fullYear
        }
    
    func data(jobs: [Job]) -> [DataInfo] {
        switch weekOrMonth {
        case .week:
            jobsByWeekDay(jobs: jobs)
        case .month:
            jobsByMonth(jobs: jobs)
        }
    }
    
    public func monthName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    public func weekdayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    public func showWeekOrMonth(date: (date: Date, count: Int)) -> String {
        weekOrMonth == .week ? weekdayName(from: date.date) : monthName(from: date.date)
    }
    
    public func getInterviewingRate(started: Double, applied: Double, rejected: Double, declined: Double, offer: Double) -> Int {
        Int((started/(started + applied + rejected + declined + offer)) * 100)
    }
    
    public func getApplicationResponseRate(started: Double, applied: Double, rejected: Double, declined: Double, offer: Double) -> Int {
        Int(((started + rejected + offer + declined) / (applied + started + rejected + declined + offer)) * 100)
    }

}
