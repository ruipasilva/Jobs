//
//  BaseViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 13/01/2025.
//

import Foundation
import Factory

public class BaseViewModel: ObservableObject {
    @Published public var localNotificationID = ""
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
    @Published public var jobURLPosting = ""
    @Published public var notes = ""
    @Published public var logoURL = ""
    @Published public var companyWebsite = ""
    @Published public var workingDays: [String] = []
    @Published public var currencyType: CurrencyType = .dolar
    
    public let workingDaysToSave: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    @Published public var showingCancelActionSheet = false
    @Published private var isTyping: Bool = false
    @Published private var timer: Timer? = nil
    @Published public var loadingLogoState: LoadingLogoState = .na
    
    @Injected(\.networkManager) var networkManager
    
    public func isLocationRemote() -> Bool {
        return locationType == .remote
    }
    
    @MainActor
    public func getLogo(company: String) async throws {
        do {
            let logo = try await networkManager.fetchLogos(query: company)
            
            guard let logoPrivate = logo.first?.logo, let domainPrivate = logo.first?.domain else { return }
            
            self.logoURL = logoPrivate
            self.companyWebsite = domainPrivate
            
        } catch {
            /// Not actually handling error because if fails,
            /// it will show a default SFSymbol if logoURL is empty
            print(error.localizedDescription)
        }
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
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.isTyping = false
            Task {
                try await self.getLogo(company: self.company)
            }
        }
    }
    
    public func handleShowAllLogosTyping() {
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
