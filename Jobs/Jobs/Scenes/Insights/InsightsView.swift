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
    
    @Query private var jobsPastShortlist: [Job]
    
    init() {
        let startedFilter = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Started" }
        let appliedFilter = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Applied" }
        let rejectedFilter = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Rejected" }
        let shortlisted = #Predicate<Job> { $0.jobApplicationStatusPrivate == "NotApplied" }
        let declined = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Declined" }
        let offeredFileter = #Predicate<Job> { $0.jobApplicationStatusPrivate == "Offer" }
        
        let jobsPastShortlist = #Predicate<Job> {
            $0.jobApplicationStatusPrivate == "Applied" &&
            $0.jobApplicationStatusPrivate == "Rejected" &&
            $0.jobApplicationStatusPrivate == "Declined" &&
            $0.jobApplicationStatusPrivate == "Offer" &&
            $0.jobApplicationStatusPrivate == "Started"
        }
        
        _startedJobs = Query(filter: startedFilter)
        _appliedJobs = Query(filter: appliedFilter)
        _rejectedJobs = Query(filter: rejectedFilter)
        _shorlistedJobs = Query(filter: shortlisted)
        _offerJobs = Query(filter: offeredFileter)
        _declinedJobs = Query(filter: declined)
        _jobsPastShortlist = Query(filter: jobsPastShortlist)
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
            .sheet(isPresented: $insightsViewModel.isShowingInterviewRateInfo) {
                InsightsInfoView(title: "Interview Rate",
                                 description:
                                    """
                                    • How often you're getting interviews after applying.
                                    • Focuses on progress rather then rejection.
                                    • Encourages to improve resumes, networking and applications if the rate is low.
                                    """
                )
                .presentationDetents([.fraction(0.3)])
            }
            .sheet(isPresented: $insightsViewModel.isShowingResponseRateInfo) {
                InsightsInfoView(title: "Application Response Rate",
                                 description:
                                    """
                                    • Shows how often applications get a response, even if it's not an offer.
                                    • Tweak your approach is response rate is low.
                                    • Encourages outreach follow-ups if needed.
                                    """
                )
                .presentationDetents([.fraction(0.3)])
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
                Button {
                    insightsViewModel.isShowingInterviewRateInfo.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }

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
                Button {
                    insightsViewModel.isShowingResponseRateInfo.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
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
