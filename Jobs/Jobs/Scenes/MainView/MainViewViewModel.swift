//
//  MainViewViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Foundation
import SwiftData
import Factory

public final class MainViewViewModel: ObservableObject {
    @Published public var isShowingNewJob = false
    @Published public var sortOrdering = SortOrdering.dateAdded
    @Published public var ascendingDescending: SortOrder = .forward
    @Published public var filter = ""
    
    @Published public var isShowingApplied = false
    @Published public var isShowingInterviewing = false
    
    @Injected(\.networkManager) private var networkManager
    @Injected(\.notificationManager) private var notificationManager
    @Injected(\.calendarManager) private var calendarManager
    
    public func sortListOrder(sorting: SortOrdering) {
        self.sortOrdering = sorting
    }
    
    public func sortAscendingOrDescending(order: SortOrder){
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


