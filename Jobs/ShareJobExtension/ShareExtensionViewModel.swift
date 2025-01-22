//
//  ShareExtensionViewModel.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 22/01/2025.
//

import Foundation

class ShareExtensionViewModel: ObservableObject {
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    @Published public var sharedURL: URL?
    @Published public var sharedText: String = ""
}
