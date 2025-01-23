//
//  EditJobViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 02/04/2024.
//

import Combine
import Factory
import Foundation
import SwiftUI


public class EditJobViewModel: BaseViewModel {
    @Published public var isShowingPasteLink = false
    @Published public var isShowingRecruiterDetails = false
    @Published public var isShowingLogoDetails = false
    @Published public var isShowingWarnings = false

    @Published public var loadingLogoState: LoadingLogoState = .na
    
//    Using @AppStorage in viewModel because it crashes the app on iOS 17.5.
//    only this view why? Does not happen on iOS 18.
    @AppStorage("count") var count: Int = 0

    public let editTip = EditTip()
    public let job: Job

    @Injected(\.networkManager) private var networkManager
    @Injected(\.notificationManager) public var notificationManager
    @Injected(\.calendarManager) public var calendarManager

    private var subcriptions = Set<AnyCancellable>()
    
    public init(job: Job) {
        self.job = job
        super.init()
        setProperties()
    }

    public func isLocationRemote() -> Bool {
        return locationType == .remote
    }

    public func updateJob() {
        job.title = title
        job.company = company
        job.jobApplicationStatus = jobApplicationStatus
        job.jobApplicationStatusPrivate = jobApplicationStatus.status
        job.location = location
        job.locationType = locationType
        job.salary = salary
        followUp = followUp
        followUpDate = followUpDate
        addInterviewToCalendar = addInterviewToCalendar
        addInterviewToCalendarDate = addInterviewToCalendarDate
        isEventAllDay = isEventAllDay
        job.recruiterName = recruiterName
        job.recruiterEmail = recruiterEmail
        job.recruiterNumber = recruiterNumber
        job.jobURLPosting = url
        job.notes = notes
        job.logoURL = logoURL
        job.companyWebsite = companyWebsite
        job.interviewQuestions = interviewQuestions
        job.workingDays = workingDaysToSave
        job.currencyType = currencyType
        job.localNotificationID = localNotificationID
    }

    public func setProperties() {
        title = job.title
        company = job.company
        jobApplicationStatus = job.jobApplicationStatus
        location = job.location
        locationType = job.locationType
        salary = job.salary
        followUp = job.followUp
        followUpDate = job.followUpDate
        addInterviewToCalendar = job.addToCalendar
        addInterviewToCalendarDate = job.addToCalendarDate
        isEventAllDay = job.isEventAllDay
        recruiterName = job.recruiterName
        recruiterEmail = job.recruiterEmail
        recruiterNumber = job.recruiterNumber
        url = job.jobURLPosting
        notes = job.notes
        logoURL = job.logoURL
        companyWebsite = job.companyWebsite
        interviewQuestions = job.interviewQuestions ?? []
        workingDaysToSave = job.workingDays
        currencyType = job.currencyType
        localNotificationID = job.localNotificationID ?? ""
    }

    public func getLogoOptionsViewModel() -> LogoOptionsViewModel {
        let viewModel = LogoOptionsViewModel(job: job)
        
        viewModel.subject
            .sink { [weak self] _ in
                // We can use unowned here instead of weak
                // 'self' owns this combine subscription
                // If 'self' is deallocated, the subscription is removed
                self?.setProperties()
            }
            .store(in: &subcriptions)

        return viewModel
    }
    
    public func setupWebsiteWarning() {
        count += 1
        isShowingWarnings = true
    }
}
