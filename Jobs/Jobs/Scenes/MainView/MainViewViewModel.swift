//
//  MainViewViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Factory
import Foundation
import SwiftData

public final class MainViewViewModel: ObservableObject {
    @Published public var isShowingNewJob = false
    @Published public var sortingOrder = SortingOrder.dateAdded
    @Published public var ascendingDescending: SortOrder = .forward
    @Published public var filter = ""

    @Published public var isShowingApplied = false
    @Published public var isShowingInterviewing = false

    public func sortAscendingOrDescending(order: SortOrder) {
        ascendingDescending = order
    }

    public func showNewJobSheet() {
        isShowingNewJob = true
    }

    public func setApplicationStatus(job: Job, status: JobApplicationStatus) {
        job.jobApplicationStatus = status
        job.jobApplicationStatusPrivate = status.status
    }
}
