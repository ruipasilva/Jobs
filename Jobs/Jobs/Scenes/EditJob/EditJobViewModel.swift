//
//  EditJobViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 02/04/2024.
//

import Foundation
import Combine
import Factory
// SwiftUI usage in View Model explained below in the @AppStorage declaration
import SwiftUI

public final class EditJobViewModel: ObservableObject {
    @Published public var localID = ""
    @Published public var calendarID = ""
    @Published public var title = ""
    @Published public var company = ""
    @Published public var applicationStatusPrivate = ""
    @Published public var jobApplicationStatus = JobApplicationStatus.notApplied
    @Published public var jobApplicationStatusPrivate = ""
    @Published public var location = ""
    @Published public var locationType = LocationType.remote
    @Published public var salary = ""
    @Published public var followUp = false
    @Published public var followUpDate = Date.distantPast
    @Published public var addInterviewToCalendar = false
    @Published public var addInterviewToCalendarDate = Date.distantPast
    @Published public var isEventAllDay = false
    @Published public var recruiterName = ""
    @Published public var recruiterEmail = ""
    @Published public var recruiterNumber = ""
    @Published public var url = ""
    @Published public var notes = ""
    @Published public var logoURL = ""
    @Published public var companyWebsite = ""
    @Published public var interviewQuestion: [InterviewQuestion] = []
    @Published public var workingDaysToSave: [String] = []
    @Published public var currencyType: CurrencyType = .dolar
    
    @Published public var isShowingPasteLink = false
    @Published public var isShowingRecruiterDetails = false
    @Published public var isShowingLogoDetails = false
    @Published var isShowingWarnings: Bool = false
    
    @Published public var loadingLogoState: LoadingLogoState = .na
    
    // Using @AppStorage in View Model as it freezes when initialised in the View (It only happens in this view - WHY?)
    @AppStorage("count") var count: Int = 0
    
    public let workingDays: [String] = ["Mon","Tue","Wed","Thu","Fri"]
    public let editTip = EditTip()
    
    @Injected(\.networkManager) private var networkManager
    @Injected(\.notificationManager) private var notificationManager
    
    private var subcriptions = Set<AnyCancellable>()
    
    public func isLocationRemote() -> Bool {
        return locationType == .remote
    }
    
    public func isShowingJobLink() {
        isShowingPasteLink.toggle()
    }
    
    public func updateJob(job: Job) {
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
        job.interviewQuestions = interviewQuestion
        job.workingDays = workingDaysToSave
        job.currencyType = currencyType
        job.localID = localID
        job.calendarID = calendarID
    }
    
    public func setProperties(job: Job) {
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
        interviewQuestion = job.interviewQuestions ?? []
        workingDaysToSave = job.workingDays
        currencyType = job.currencyType
        localID = job.localID
        calendarID = job.calendarID
    }
    
    public func getLogoOptionsViewModel() -> LogoOptionsViewModel {
        let viewModel = LogoOptionsViewModel()
        
        viewModel.subject
            .sink { [weak self] job in
                self?.company = job.company
                self?.title = job.title
                self?.logoURL = job.logoURL
                self?.companyWebsite = job.companyWebsite
            }
            .store(in: &subcriptions)
        
        return viewModel
    }
    
    public func setupWebsiteWarning() {
        count += 1
        isShowingWarnings = true
    }
}
