//
//  LogoOptionsViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 04/04/2024.
//


import Factory
import Foundation
import Combine

public final class LogoOptionsViewModel: BaseViewModel {
    
    
    @Published public var initialCompanyName: String = ""
    @Published public var initialJobTitle: String = ""
    
    public var subject = PassthroughSubject<Job, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    public let job: Job
    
    @Published public var isTyping: Bool = false
    @Published private var timer: Timer? = nil
    
    public init(job: Job) {
        self.job = job
    }
    
    public func showDiscardDialog() {
        showingCancelActionSheet = true
    }
    
    public func shouldCancelWithoutDialogAlert() -> Bool {
        initialCompanyName == company && initialJobTitle == title
    }
    
    public func setProperties() {
        title = job.title
        company = job.company
        logoURL = job.logoURL
        companyWebsite = job.companyWebsite
        initialCompanyName = job.company
        initialJobTitle = job.title
    }
    
    public func updateJob() {
        job.title = title
        job.company = company
        job.logoURL = logoURL
        job.companyWebsite = companyWebsite
        subject.send(job)
    }
    
    public func setLogoInfo(companyInfo data: CompanyInfo) {
        logoURL = data.logo
        companyWebsite = data.domain
    }
    
    public func isTitleOrCompanyEmpty() -> Bool {
        return title.isEmpty || company.isEmpty
    }
}
