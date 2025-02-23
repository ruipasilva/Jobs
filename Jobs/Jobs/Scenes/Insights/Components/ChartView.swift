//
//  ChartView.swift
//  Jobs
//
//  Created by Rui Silva on 22/02/2025.
//

import SwiftUI
import SwiftData
import Charts

struct ChartView: View {
    @ObservedObject private var insightsViewModel: InsightsViewModel
    
    @Query private var jobs: [Job]
    @Query private var appliedJobs: [Job]
    @Query private var rejectedJobs: [Job]
    @Query private var shorlistedJobs: [Job]
    @Query private var startedJobs: [Job]
    @Query private var declinedJobs: [Job]
    @Query private var offerJobs: [Job]
    
    @Query private var jobsPastShortlist: [Job]
    
    public init(insightsViewModel: InsightsViewModel) {
        self.insightsViewModel = insightsViewModel
        
        let jobsPastShortlist = #Predicate<Job> { $0.jobApplicationStatusPrivate != "Shortlisted" }
        _jobsPastShortlist = Query(filter: jobsPastShortlist)
    }
    var body: some View {
        Picker("Time", selection: $insightsViewModel.weekOrYear) {
            ForEach(WeekOrYear.allCases, id: \.id) { time in
                Text(time.time).tag(time)
            }
        }
        .padding(.bottom)
        .pickerStyle(.segmented)
        VStack(alignment: .leading) {
            Text("Applications This \(insightsViewModel.weekOrYear == .week ? "Week" : "Year")")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            Text(insightsViewModel.weekOrYear == .week ?
                 "\(insightsViewModel.filteredAppliedJobsByWeek(jobs: jobsPastShortlist).count)" :
                    "\(insightsViewModel.filteredAppliedJobsByYear(jobs: jobsPastShortlist).count)")
                .font(.largeTitle)
                .fontWeight(.medium)
            Text(insightsViewModel.weekOrYear == .week ? insightsViewModel.getDateWithCurrentWeek() : insightsViewModel.getDateWithCurrentYear())
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            TabView(selection: $insightsViewModel.currentIndex ) {
                ForEach(insightsViewModel.weekOffsets, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Chart(insightsViewModel.data(jobs: jobsPastShortlist, offset: index), id: \.date) { date in
                            BarMark(
                                x: .value("Day", insightsViewModel.showWeekOrMonth(date: date)),
                                y: .value("Count", date.count)
                            )
                        }
                        .chartYScale(domain: 0...(insightsViewModel.data(jobs: jobsPastShortlist, offset: index).map(\.count).max() ?? 2) + 1)
                        .padding(.horizontal)
                        .padding(.top, 4)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
        }
    }
}
