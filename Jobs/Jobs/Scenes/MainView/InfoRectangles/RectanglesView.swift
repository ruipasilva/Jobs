//
//  RectanglesView.swift
//  Jobs
//
//  Created by Rui Silva on 01/04/2024.
//

import SwiftData
import SwiftUI

struct RectanglesView: View {
    @ObservedObject private var mainViewModel: MainViewViewModel

    @Query private var appliedJobs: [Job]
    @Query private var startedJobs: [Job]

    var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: 2)
    }

    public init(mainViewModel: MainViewViewModel) {
        self.mainViewModel = mainViewModel

        let appliedFilter = #Predicate<Job> { job in
            job.jobApplicationStatusPrivate == "Applied"
        }

        let startedFilter = #Predicate<Job> { job in
            job.jobApplicationStatusPrivate == "Started"
        }

        _appliedJobs = Query(filter: appliedFilter)
        _startedJobs = Query(filter: startedFilter)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            SingleRectangleView(
                mainViewModel: mainViewModel, totalJobs: appliedJobs.count,
                interviewStatus: JobApplicationStatus.applied.status,
                SFSymbol: "checkmark", circleColor: Color(uiColor: .systemOrange)
            )
            .onTapGesture {
                mainViewModel.isShowingAppliedJobs = true
            }
            SingleRectangleView(
                mainViewModel: mainViewModel, totalJobs: startedJobs.count,
                interviewStatus: JobApplicationStatus.started.status,
                SFSymbol: "arrow.right", circleColor: Color(uiColor: .systemIndigo)
            )
            .onTapGesture {
                mainViewModel.isShowingStartedJobs = true
            }
        }
        .sheet(isPresented: $mainViewModel.isShowingAppliedJobs) {
            SingleJobStatusView(mainViewModel: mainViewModel, jobs: appliedJobs, title: "Applied")
        }
        .sheet(isPresented: $mainViewModel.isShowingStartedJobs) {
            SingleJobStatusView(mainViewModel: mainViewModel, jobs: startedJobs, title: "started")
        }
    }
}
