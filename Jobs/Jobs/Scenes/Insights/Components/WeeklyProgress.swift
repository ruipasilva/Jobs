//
//  WeeklyProgress.swift
//  Jobs
//
//  Created by Rui Silva on 22/02/2025.
//

import SwiftUI
import SwiftData

struct WeeklyProgress: View {
    @ObservedObject private var insightsViewModel: InsightsViewModel
    @AppStorage("target") private var weeklyTarget: Int = 0
    
    @Query private var jobsPastShortlist: [Job]
    
    private var weeklyTargetBinding: Binding<String> {
        Binding(
            get: { String(weeklyTarget) },
            set: { newValue in
                if let intValue = Int(newValue) {
                    weeklyTarget = intValue
                }
            }
        )
    }
    
    var thisWeekProgress: Double {
        let appliedJobs = insightsViewModel.filteredAppliedJobsForCurrentWeek(jobs: jobsPastShortlist).count
        return weeklyTarget > 0 ? min(Double(appliedJobs) / Double(weeklyTarget), 1.0) : 0.0
    }
    
    var previousWeekProgress: Double {
        let appliedJobs = insightsViewModel.filteredAppliedJobsForPreviousWeek(jobs: jobsPastShortlist).count
        return weeklyTarget > 0 ? min(Double(appliedJobs) / Double(weeklyTarget), 1.0) : 0.0
    }
    
    public init(insightsViewModel: InsightsViewModel) {
        self.insightsViewModel = insightsViewModel
        
        let jobsPastShortlist = #Predicate<Job> { $0.jobApplicationStatusPrivate != "Shortlisted" }
        _jobsPastShortlist = Query(filter: jobsPastShortlist)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("So far this week you have applied to more jobs than last week.")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.bottom, 11)
                .padding(.trailing, 45)
            HStack {
                Text("Target")
                Spacer()
                TextField("Target", text: weeklyTargetBinding)
                    .keyboardType(.numberPad)
            }
            Text("\(insightsViewModel.filteredAppliedJobsForCurrentWeek(jobs: jobsPastShortlist).count)")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 3)
            WeeklyProgressBar(progress: thisWeekProgress, barColor: .mint, text: "This Week")
                .padding(.bottom, 17)
            Text("\(insightsViewModel.filteredAppliedJobsForPreviousWeek(jobs: jobsPastShortlist).count)")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 3)
            WeeklyProgressBar(progress: previousWeekProgress, barColor: Color(uiColor: .systemGray4), text: "Last Week")
                .padding(.bottom, 17)
        }
        .padding(16)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor.systemGray3).opacity(0.48), lineWidth: 1)
            
        }
        .padding(.top, 45)
        .padding(.bottom, 20)
    }
}
