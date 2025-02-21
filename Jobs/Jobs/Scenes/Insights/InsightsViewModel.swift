//
//  InsightsViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 06/07/2024.
//

import Foundation

public final class InsightsViewModel: ObservableObject {
    @Published public var weekOrYear: WeekOrYear = .week
    @Published public var isShowingInterviewRateInfo: Bool = false
    @Published public var isShowingResponseRateInfo: Bool = false
    
    @Published var currentIndex: Int = 0
    
    typealias DataInfo = (date: Date, count: Int)
    
    func getDateWithCurrentWeek() -> String {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())

        // Get the start of the current week
        let today = Date()
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start else {
            return ""
        }

        // Adjust for the currentWeekIndex offset
        let adjustedStartOfWeek = calendar.date(byAdding: .weekOfYear, value: currentIndex, to: startOfWeek)!
        let adjustedEndOfWeek = calendar.date(byAdding: .day, value: 6, to: adjustedStartOfWeek)!

        // Format the output
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"

        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"

        let combinedDateString = "\(monthFormatter.string(from: adjustedStartOfWeek)) \(dayFormatter.string(from: adjustedStartOfWeek))-\(dayFormatter.string(from: adjustedEndOfWeek)), \(currentYear)"

        return combinedDateString
    }
    
    func getDateWithCurrentYear() -> String {
        let calendar = Calendar.current
        let today = Date()

        // Adjust the year based on the scrolling offset (currentWeekIndex is used as year offset)
        guard let adjustedYearDate = calendar.date(byAdding: .year, value: currentIndex, to: today) else {
            return ""
        }

        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        return yearFormatter.string(from: adjustedYearDate)
    }
    
    func filteredAppliedJobs(jobs: [Job]) -> [Job] {
        let calendar = Calendar.current
        let today = Date()
        
        // Get the start of the current week
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start else {
            return []
        }
        
        // Adjust start of the week based on scrolling offset
        let adjustedStartOfWeek = calendar.date(byAdding: .weekOfYear, value: currentIndex, to: startOfWeek)!
        let adjustedEndOfWeek = calendar.date(byAdding: .day, value: 6, to: adjustedStartOfWeek)!
        
        // Filter jobs applied within the adjusted week
        let filteredJobs = jobs.compactMap { (job: Job) -> Job? in
            guard let applicationDate = job.appliedDate else { return nil }
                return (applicationDate >= adjustedStartOfWeek && applicationDate <= adjustedEndOfWeek) ? job : nil
            }
            
            return filteredJobs
    }
    
    func jobsByWeekDay(jobs: [Job], weekOffset: Int) -> [DataInfo] {
        let calendar = Calendar.current
        let today = Date()
        
        // Get the start of the current week and adjust by weekOffset
        guard let startOfWeek = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!) else {
            return []
        }
        
        let fullWeek = (0..<7).compactMap { dayOffset -> DataInfo in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)!
            return (date, 0)
        }
        
        let validJobs = jobs.compactMap { job -> (Date, Job)? in
            guard let applicationDate = job.appliedDate else { return nil }
            let jobDate = calendar.startOfDay(for: applicationDate)
            
            // Filter jobs only within the current week range
            if jobDate >= startOfWeek && jobDate < calendar.date(byAdding: .day, value: 7, to: startOfWeek)! {
                return (jobDate, job)
            }
            return nil
        }
        
        let grouped = Dictionary(grouping: validJobs, by: { calendar.startOfDay(for: $0.0) })
        let jobCounts = grouped.mapValues { $0.count }
        
        return fullWeek.map { (date, count) in
            (date, jobCounts[date] ?? count)
        }
    }
    
    func jobsByMonth(jobs: [Job], yearOffset: Int) -> [DataInfo] {
        let calendar = Calendar.current
        let today = Date()

        // Adjust the year based on yearOffset
        guard let startOfYear = calendar.date(byAdding: .year, value: yearOffset, to: calendar.date(from: calendar.dateComponents([.year], from: today))!) else {
            return []
        }

        let selectedYear = calendar.component(.year, from: startOfYear)

        var fullYear = (1...12).compactMap { month -> DataInfo in
            let date = calendar.date(from: DateComponents(year: selectedYear, month: month, day: 1))!
            return (date, 0)
        }

        // Filter jobs for the selected year
        let filteredJobs = jobs.filter { job in
            guard let jobDate = job.appliedDate else { return false }
            return calendar.component(.year, from: jobDate) == selectedYear
        }

        // Group jobs by month
        let grouped = Dictionary(grouping: filteredJobs, by: {
            calendar.date(from: calendar.dateComponents([.year, .month], from: $0.appliedDate!))!
        })

        let jobCounts = grouped.mapValues { $0.count }

        // Update fullYear with actual job counts
        for i in fullYear.indices {
            let month = fullYear[i].date
            if let count = jobCounts[month] {
                fullYear[i] = (month, count)
            }
        }

        return fullYear
    }
    func data(jobs: [Job], offset: Int) -> [DataInfo] {
        switch weekOrYear {
        case .week:
            jobsByWeekDay(jobs: jobs, weekOffset: offset)
        case .year:
            jobsByMonth(jobs: jobs, yearOffset: offset)
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
        weekOrYear == .week ? weekdayName(from: date.date) : monthName(from: date.date)
    }
    
    public func getInterviewingRate(started: Double, applied: Double, rejected: Double, declined: Double, offer: Double) -> Int {
        Int((started/(started + applied + rejected + declined + offer)) * 100)
    }
    
    public func getApplicationResponseRate(started: Double, applied: Double, rejected: Double, declined: Double, offer: Double) -> Int {
        Int(((started + rejected + offer + declined) / (applied + started + rejected + declined + offer)) * 100)
    }

}
