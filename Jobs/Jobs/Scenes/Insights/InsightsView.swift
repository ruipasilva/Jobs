//
//  InsightsView.swift
//  Jobs
//
//  Created by Rui Silva on 06/07/2024.
//

import SwiftUI
import SwiftData
import Charts

struct InsightsView: View {
    @StateObject private var insightsViewModel = InsightsViewModel()
    
    @Query private var jobs: [Job]
    @Query private var appliedJobs: [Job]
    @Query private var rejectedJobs: [Job]
    @Query private var shorlistedJobs: [Job]
    @Query private var startedJobs: [Job]
    @Query private var declinedJobs: [Job]
    @Query private var offerJobs: [Job]
    
    init() {
        let startedFilter = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Started" }
        let appliedFilter = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Applied" }
        let rejectedFilter = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Rejected" }
        let shortlisted = #Predicate<Job> { $0.jobApplicationStatusPrivate == "NotApplied" }
        let declined = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Declined" }
        let offeredFileter = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Offer" }
        
        _startedJobs = Query(filter: startedFilter)
        _appliedJobs = Query(filter: appliedFilter)
        _rejectedJobs = Query(filter: rejectedFilter)
        _shorlistedJobs = Query(filter: shortlisted)
        _offerJobs = Query(filter: offeredFileter)
        _declinedJobs = Query(filter: declined)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                totalJobsView
                rateView
                Picker("Time", selection: $insightsViewModel.weekOrMonth) {
                    ForEach(WeekOrMonth.allCases, id: \.id) { time in
                        Text(time.time).tag(time)
                    }
                }
                .padding(.bottom)
                .pickerStyle(.segmented)
                
                VStack(alignment: .leading) {
                    Text("Applications This Week")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Text("\(appliedJobs.count)")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                    Text(insightsViewModel.getDateWithCurrentWeek())
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Chart(insightsViewModel.data(jobs: appliedJobs), id: \.date) { date in
                        BarMark(
                            x: .value("day", insightsViewModel.showWeekOrMonth(date: date)),
                            y: .value("Count", date.count)
                        )
                    }
                    .chartYScale(domain: 0...(insightsViewModel.data(jobs: appliedJobs).map(\.count).max() ?? 2) + 1)
                    .frame(height: 300)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .navigationTitle("Insights")
        }
    }
    
    private var totalJobsView: some View {
        HStack {
            Text("Total")
                .font(.body)
            Spacer()
            Text("\(jobs.count)")
                .font(.body)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 13)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor.systemGray3).opacity(0.48), lineWidth: 1)
                
        }
        .padding(.top, 19)
        .padding(.bottom, 15)
    }
    
    private var rateView: some View {
        VStack {
            HStack {
                Text("Interview Rate")
                    .font(.body)
                Spacer()
                Text("\(insightsViewModel.getInterviewingRate(started: Double(startedJobs.count), applied: Double(appliedJobs.count), rejected: Double(rejectedJobs.count), declined: Double(declinedJobs.count), offer: Double(offerJobs.count)))%")
                    .font(.body)
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 13)
            Divider()
                .foregroundStyle(Color(uiColor: .systemGray3))
                .padding(.horizontal, 14)
            HStack {
                Text("Application Response Rate")
                    .font(.body)
                Spacer()
                Text("\(insightsViewModel.getApplicationResponseRate(started: Double(startedJobs.count), applied: Double(appliedJobs.count), rejected: Double(rejectedJobs.count), declined: Double(declinedJobs.count), offer: Double(offerJobs.count)))%")
                    .font(.body)
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 13)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor.systemGray3).opacity(0.48), lineWidth: 1)
                
        }
        .padding(.bottom, 45)
    }
}

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
