//
//  RectanglesView.swift
//  Jobs
//
//  Created by Rui Silva on 01/04/2024.
//

import SwiftUI
import SwiftData

struct RectanglesView: View {
    @ObservedObject private var appViewModel: MainViewViewModel
    
    @Query private var appliedJobs: [Job]
    @Query private var ongoingJobs: [Job]
    
    var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: 2)
    }
    
    public init(appViewModel: MainViewViewModel) {
        self.appViewModel = appViewModel
        
        let appliedFilter = #Predicate<Job> { job in
            job.jobApplicationStatusPrivate == "Applied"
        }
        
        let ongoingFilter = #Predicate<Job> { job in
            job.jobApplicationStatusPrivate == "Ongoing"
        }
        
        _appliedJobs = Query(filter: appliedFilter)
        _ongoingJobs = Query(filter: ongoingFilter)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            SingleRectangleView(appViewModel: appViewModel, totalJobs: appliedJobs.count, interviewStatus: JobApplicationStatus.applied.status, SFSymbol: "clock", circleColor: .orange)
                .onTapGesture {
                    appViewModel.isShowingApplied = true
                }
            SingleRectangleView(appViewModel: appViewModel, totalJobs: ongoingJobs.count, interviewStatus: JobApplicationStatus.ongoing.status, SFSymbol: "checkmark", circleColor: .mint)
                .onTapGesture {
                    appViewModel.isShowingInterviewing = true
                }
        }
        .sheet(isPresented: $appViewModel.isShowingApplied) {
            RectDetailView(appViewModel: appViewModel, jobs: appliedJobs, title: "Applied")
        }
        .sheet(isPresented: $appViewModel.isShowingInterviewing) {
            RectDetailView(appViewModel: appViewModel, jobs: ongoingJobs, title: "ongoing")
        }
    }
}
