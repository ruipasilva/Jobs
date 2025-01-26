//
//  EditJobViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 02/04/2024.
//

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
    public var job: Job

    @Injected(\.notificationManager) public var notificationManager
    @Injected(\.calendarManager) public var calendarManager
    
    public init(job: Job) {
        self.job = job
        super.init()
    }
    
    public func isLocationOnSite() -> Bool {
        return job.locationType == .remote
    }
    
    public func setupWebsiteWarning() {
        count += 1
        isShowingWarnings = true
    }
}
