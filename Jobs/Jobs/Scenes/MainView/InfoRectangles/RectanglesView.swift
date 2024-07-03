//
//  RectanglesView.swift
//  Jobs
//
//  Created by Rui Silva on 01/04/2024.
//

import SwiftUI
import SwiftData

struct RectanglesView: View {
    @ObservedObject private var appViewModel: AppViewModel
    
    @Query private var appliedJobs: [Job]
    @Query private var interviewingJobs: [Job]
    
    var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: 2)
    }
    
    public init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        
        let appliedFilter = #Predicate<Job> { job in
            job.jobApplicationStatusPrivate == "Applied"
        }
        
        let interviewingFilter = #Predicate<Job> { job in
            job.jobApplicationStatusPrivate == "ongoing"
        }
        
        _appliedJobs = Query(filter: appliedFilter)
        _interviewingJobs = Query(filter: interviewingFilter)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            SingleRectangleView(appViewModel: appViewModel, totalJobs: appliedJobs.count, interviewStatus: JobApplicationStatus.applied.status, SFSymbol: "clock", circleColor: .orange)
                .onTapGesture {
                    appViewModel.isShowingApplied = true
                }
            SingleRectangleView(appViewModel: appViewModel, totalJobs: interviewingJobs.count, interviewStatus: JobApplicationStatus.ongoing.status, SFSymbol: "checkmark", circleColor: .mint)
                .onTapGesture {
                    appViewModel.isShowingInterviewing = true
                }
        }
        .sheet(isPresented: $appViewModel.isShowingApplied) {
            RectDetailView(appViewModel: appViewModel, jobs: appliedJobs, title: "Applied")
        }
        .sheet(isPresented: $appViewModel.isShowingInterviewing) {
            RectDetailView(appViewModel: appViewModel, jobs: interviewingJobs, title: "ongoing")
        }
    }
}
