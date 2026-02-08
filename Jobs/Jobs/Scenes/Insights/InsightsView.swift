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

    // Computed properties for filtered jobs (single pass through data)
    private var startedJobs: [Job] {
        jobs.filter { $0.jobApplicationStatusPrivate == "Started" }
    }

    private var appliedJobs: [Job] {
        jobs.filter { $0.jobApplicationStatusPrivate == "Applied" }
    }

    private var rejectedJobs: [Job] {
        jobs.filter { $0.jobApplicationStatusPrivate == "Rejected" }
    }

    private var declinedJobs: [Job] {
        jobs.filter { $0.jobApplicationStatusPrivate == "Declined" }
    }

    private var offerJobs: [Job] {
        jobs.filter { $0.jobApplicationStatusPrivate == "Offer" }
    }

    private var jobsPastShortlist: [Job] {
        jobs.filter { $0.jobApplicationStatusPrivate != "Shortlisted" }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    totalJobsView
                    rateView
                    ChartView(insightsViewModel: insightsViewModel, jobsPastShortlist: jobsPastShortlist)
                    WeeklyProgress(insightsViewModel: insightsViewModel, jobsPastShortlist: jobsPastShortlist)
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
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
                Text("\(insightsViewModel.getInterviewingRate(jobs: jobsPastShortlist, started: Double(startedJobs.count), applied: Double(appliedJobs.count), rejected: Double(rejectedJobs.count), declined: Double(declinedJobs.count), offer: Double(offerJobs.count)))%")
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
                Text("\(insightsViewModel.getApplicationResponseRate(jobs: jobsPastShortlist, started: Double(startedJobs.count), applied: Double(appliedJobs.count), rejected: Double(rejectedJobs.count), declined: Double(declinedJobs.count), offer: Double(offerJobs.count)))%")
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
        .padding(.bottom, 15)
    }
}


