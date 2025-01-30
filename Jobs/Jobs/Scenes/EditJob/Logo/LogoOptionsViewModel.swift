//
//  LogoOptionsViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 04/04/2024.
//


import Factory
import Foundation
import Combine

public final class LogoOptionsViewModel: ObservableObject {
    
    @Published public var title: String = ""
    @Published public var company: String = ""
    @Published public var logoURL: String = ""
    @Published public var companyWebsite: String = ""
    
    @Published public var initialCompanyName: String = ""
    @Published public var initialJobTitle: String = ""
    
    public var subject = PassthroughSubject<Job, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Injected(\.networkManager) private var networkManager
    
    public let job: Job
    
    @Published public var loadingLogoState: LoadingLogoState = .na
    @Published public var showingCancelActionSheet = false
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
    
    @MainActor
    public func getLogos(company: String) async throws {
        loadingLogoState = .loading
        
        do {
            let logoData = try await networkManager.fetchLogos(query: company)
            
            if logoData.isEmpty {
                logoURL = ""
                loadingLogoState = .na
                return
            }
            
            loadingLogoState = .success(data: logoData)
        } catch {
            loadingLogoState = .failed(error: .unableToComplete)
        }
    }
    
    public func handleTyping() {
        isTyping = true
        loadingLogoState = .loading
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.isTyping = false
            Task {
                try await self.getLogos(company: self.company)
            }
        }
    }
}
