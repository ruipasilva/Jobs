//
//  AppViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2024.
//

import Foundation
import SwiftData
import UIKit

public final class AppViewModel: ObservableObject {
    @Published public var isShowingNewJob = false
    @Published public var isNewJobExpanded = false
    @Published public var sortOrdering = SortOrdering.title
    @Published public var ascendingDescending: SortOrder = .forward
    @Published public var filter = ""
    
    public func sortListOrder(sorting: SortOrdering) {
        self.sortOrdering = sorting
    }
    
    public func sortAscendingOrDescending(order: SortOrder){
        ascendingDescending = order
    }
    
    public func showNewJobSheet() {
        isShowingNewJob = true
    }
}


