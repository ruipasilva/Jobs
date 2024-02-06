//
//  AppViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Foundation
import SwiftData
import SwiftUI

public final class AppViewModel: ObservableObject {
    @Published public var isShowingNewJob = false
    @Published public var isNewJobExpanded = false
    @Published public var sortOrder = SortOrder.company
    @Published public var filter = ""
    @Published public var selectedDetent: PresentationDetent = .medium
    public let availableDetents: Set<PresentationDetent> = [.medium, .large]
    
    public func setPresentationDetents() {
        isNewJobExpanded.toggle()
        
        if isNewJobExpanded {
            selectedDetent = .large
        } else {
            selectedDetent = .medium
        }
    }
    
    public func onDismissNewJobSheet() {
        selectedDetent = .medium
        isNewJobExpanded = false
    }
}
