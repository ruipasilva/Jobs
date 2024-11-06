//
//  MainViewViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Foundation
import SwiftData

public final class MainViewViewModel: ObservableObject {
    @Published public var isShowingNewJob = false
    @Published public var sortOrdering = SortOrdering.dateAdded
    @Published public var ascendingDescending: SortOrder = .forward
    @Published public var filter = ""
    
    @Published public var isShowingApplied = false
    @Published public var isShowingInterviewing = false
    
    public let networkManager: NetworkManaging
    public let calendarManager: CalendarManaging
    public let notificationManager: NotificationManaging
    
    init(networkManager: NetworkManaging = NetworkManager(),
         calendarManager: CalendarManaging = CalendarManager(),
         notificationManager: NotificationManaging = NotificationManager()) {
        self.networkManager = networkManager
        self.calendarManager = calendarManager
        self.notificationManager = notificationManager
    }
    
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


