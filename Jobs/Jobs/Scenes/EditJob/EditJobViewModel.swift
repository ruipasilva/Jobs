//
//  EditJobViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 02/04/2024.
//

import Factory
import Foundation
import SwiftUI
import Combine
import MapKit
import SwiftData


public class EditJobViewModel: BaseViewModel {
    @Published public var isShowingPasteLink = false
    @Published public var isShowingRecruiterDetails = false
    @Published public var isShowingLogoDetails = false
    @Published public var isShowingWarnings = false
    @Published public var isShowingDeleteAlert = false
    @Published public var isShowingMapView = false
    
    @Published public var initialCompanyName: String = ""
    @Published public var initialJobTitle: String = ""
    
    @Published public var mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default location (e.g., San Francisco)
            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        )
    @Published public var selectedLocation: [IdentifiableLocation] = []
    
    //    Using @AppStorage in viewModel because it crashes the app on iOS 17.5.
    //    only this view why? Does not happen on iOS 18.
    @AppStorage("count") var count: Int = 0
    
    public let editTip = EditTip()
    public var job: Job
    
    @Injected(\.notificationManager) public var notificationManager
    @Injected(\.calendarManager) public var calendarManager
    @Injected(\.storageManager) public var storageManager
    
    private var subcriptions = Set<AnyCancellable>()
    
    public init(job: Job) {
        self.job = job
        super.init()
    }
    
    public func onAppear() {
        initialCompanyName = job.company
        initialJobTitle = job.title
    }
    
    public func onDisappear() {
        storageManager.edit(initialJobTitle: initialJobTitle,
                            initialCompanyName: initialCompanyName,
                            jobTitle: &job.title,
                            jobCompany: &job.company)
    }
    
    public func deleteJob(context: ModelContext) {
        storageManager.delete(job: job, context: context)
    }
    
    public func isLocationOnSite() -> Bool {
        return job.locationType == .remote
    }
    
    public func setupWebsiteWarning() {
        count += 1
        isShowingWarnings = true
    }
    
    public func setProperties() {
        title = job.title
        company = job.company
    }
    
    public func setApplicationDate() {
        if job.jobApplicationStatus == .notApplied {
            job.appliedDate = nil
        }
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
    
    public func makePhoneCall(phoneNumber: String) {
        if let phoneURL = URL(string: "tel:\(phoneNumber)") {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    @MainActor
    public func performMapSearch() {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = job.location
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            
            if let error = error {
                print("Search error: \(error.localizedDescription)")
                return
            }
            
            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                            let location = IdentifiableLocation(coordinate: coordinate)
                            self.selectedLocation = [location]
                            self.mapRegion = MKCoordinateRegion(
                                center: coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
                            )
                        }
        }
    }
}

