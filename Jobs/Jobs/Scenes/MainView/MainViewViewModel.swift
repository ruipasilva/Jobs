//
//  MainViewViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Factory
import Foundation
import SwiftData
import Combine

public final class MainViewViewModel: ObservableObject {
    @Published public var sortingOrder = SortingOrder.dateAdded
    @Published public var ascendingDescending: SortOrder = .forward
    @Published public var filter = ""
    @Published public var isShowingNewJobView = false
    @Published public var isShowingAppliedJobs = false
    @Published public var isShowingStartedJobs = false

    public func sortAscendingOrDescending(order: SortOrder) {
        ascendingDescending = order
    }

    public func showNewJobSheet() {
        isShowingNewJobView = true
    }

    public func setApplicationStatus(job: Job, status: JobApplicationStatus) {
        job.jobApplicationStatus = status
        job.jobApplicationStatusPrivate = status.status
        setApplicationDate(job: job, status: status)
    }
    
    private func setApplicationDate(job: Job, status: JobApplicationStatus) {
        if status != .notApplied {
            job.appliedDate = Date()
        } else {
            job.appliedDate = nil
        }
    }
}
