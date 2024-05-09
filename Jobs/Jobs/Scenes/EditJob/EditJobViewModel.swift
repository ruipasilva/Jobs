//
//  EditJobViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 02/04/2024.
//

import Foundation
import Combine

public final class EditJobViewModel: ObservableObject {
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
    @Published public var interviewQuestion: [InterviewQuestion] = []
    
    @Published public var isShowingPasteLink = false
    @Published public var isShowingRecruiterDetails = false
    @Published public var isShowingLogoDetails = false
    
    @Published public var loadingLogoState: LoadingLogoState = .na
    
    public let networkManager: NetworkManaging
    public let editTip = EditTip()
    
    private var subcriptions = Set<AnyCancellable>()
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
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
        job.interviewQuestions = interviewQuestion
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
        interviewQuestion = job.interviewQuestions ?? []
    }
    
    public func getLogoOptionsViewModel() -> LogoOptionsViewModel {
        let viewModel = LogoOptionsViewModel(networkManager: networkManager)
        
        viewModel.subject
            .sink { [weak self] job in
                self?.company = job.company
                self?.title = job.title
                self?.logoURL = job.logoURL
            }
            .store(in: &subcriptions)
        
        return viewModel
    }
    
    @MainActor
    public func getLogos(company: String) async {
        loadingLogoState = .na
        
        do {
            let logoData = try await networkManager.fetchData(query: company)
            
            if logoData.isEmpty {
                logoURL = ""
            }
            
            self.logoURL = logoData.first?.logo ?? ""
            
            loadingLogoState = .success(data: logoData)
        } catch {
            loadingLogoState = .failed(error: .unableToComplete)
        }
    }
}
