//
//  LogoOptionsViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 04/04/2024.
//


import Factory
import Foundation

public final class LogoOptionsViewModel: BaseViewModel {
    
    public var job: Job
    
    public init(job: Job) {
        self.job = job
    }

    @Published public var loadingLogoState: LoadingLogoState = .na

    public func isTitleOrCompanyEmpty() -> Bool {
        return job.title.isEmpty || job.company.isEmpty
    }

    @MainActor
    public func getLogos(company: String) async {
        loadingLogoState = .na

        do {
            let logoData = try await networkManager.fetchLogos(query: company)

            if logoData.isEmpty {
                job.logoURL = ""
            }

            loadingLogoState = .success(data: logoData)
        } catch {
            loadingLogoState = .failed(error: .unableToComplete)
        }
    }
}
