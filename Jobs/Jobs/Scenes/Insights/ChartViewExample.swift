//
//  ChartViewExample.swift
//  Jobs
//
//  Created by Rui Silva on 20/02/2025.
//

import SwiftUI
import Charts
import SwiftData

struct ChartViewExample: View {
    
    @Query private var appliedJobs: [Job]
    
    @State private var chartData: [ChartData] = []
//    @State private var startDate = getMonday(of: Date())
    
    init() {
        let appliedFilter = #Predicate<Job> { $0.jobApplicationStatusPrivate != "Shortlisted" }
        
        
        _appliedJobs = Query(filter: appliedFilter)
    }
    
    var body: some View {
        NavigationStack {
            Chart(chartData, id: \.date) { job in
                BarMark(
                    x: .value("Date", job.date, unit: .day),
                    y: .value("Totals", job.count)
                )
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                        if let date = value.as(Date.self) {
                            let weekday = Calendar.current.component(.weekday, from: date)
                            if weekday >= 2 && weekday <= 6 { // Only show Monday–Friday
                                AxisValueLabel(formatDate(date))
                            }
                        }
                    }                    }
            .frame(height: 300)
//            .chartScrollableAxes(.horizontal)
//            .chartXVisibleDomain(length: 7)
//            .chartScrollTargetBehavior(.paging)
            .padding(.horizontal)
        }
    }
    
   
    
    func getMonday(of date: Date) -> Date {
           let calendar = Calendar.current
           let weekday = calendar.component(.weekday, from: date)
           let daysToSubtract = (weekday == 1) ? 6 : weekday - 2 // Adjust for Sunday being 1
           return calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
       }
    
//    func generateWeeklyData(chartData: [ChartData]) -> [ChartData] {
//           let calendar = Calendar.current
//        var data = chartData
//
//           for weekOffset in -5...5 { // 5 weeks before & after current week
//               let monday = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: startDate)!
//               
//               for dayOffset in 0..<7 { // Generate Monday to Sunday
//                   if let date = calendar.date(byAdding: .day, value: dayOffset, to: monday) {
//                       data.append(ChartData(date: date))
//                   }
//               }
//           }
//           return data
//       }
    
    func setupChartData(appliedJobs: [Job]) -> [ChartData] {
        let calendar = Calendar.current
        
        let groupedJobs = Dictionary(grouping: appliedJobs) { job in
            Calendar.current.startOfDay(for: job.appliedDate ?? Date.distantPast)
        }
        
        return groupedJobs
            .compactMap { (date, jobs) in
                let weekday = calendar.component(.weekday, from: date)
                if weekday >= 2 && weekday <= 6 { // Monday (2) to Friday (6)
                    return ChartData(date: date, count: jobs.count)
                }
                return nil
            }
            .sorted { $0.date < $1.date }
    }
    
    func formatDate(_ date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return date.map { formatter.string(from: $0) } ?? ""
    }
}



#Preview {
    ChartViewExample()
}
