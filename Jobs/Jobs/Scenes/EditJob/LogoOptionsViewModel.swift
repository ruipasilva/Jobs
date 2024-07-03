//
//  LogoOptionsViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 04/04/2024.
//

import Foundation
import Combine

public final class LogoOptionsViewModel: ObservableObject {
    @Published public var title: String = ""
    @Published public var company: String = ""
    @Published public var logoURL: String = ""
    @Published public var companyWebsite: String = ""
    
    public var subject = PassthroughSubject<Job, Never>()
    
    @Published public var loadingLogoState: LoadingLogoState = .na
    
    private let networkManager: NetworkManaging
    
    public init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    public func isTitleOrCompanyEmpty() -> Bool {
        return title.isEmpty || company.isEmpty
    }
    
    public func setProperties(job: Job) {
        title = job.title
        company = job.company
        logoURL = job.logoURL
        companyWebsite = job.companyWebsite
    }
    
    public func updateJob(job: Job) {
        job.title = title
        job.company = company
        job.logoURL = logoURL
        job.companyWebsite = companyWebsite
        subject.send(job)
    }
    
    @MainActor
    public func getLogos(company: String) async {
        loadingLogoState = .na
        
        do {
            let logoData = try await networkManager.fetchData(query: company)
            
            if logoData.isEmpty {
                logoURL = ""
            }
            
            loadingLogoState = .success(data: logoData)
        } catch {
            loadingLogoState = .failed(error: .unableToComplete)
        }
    }
}
