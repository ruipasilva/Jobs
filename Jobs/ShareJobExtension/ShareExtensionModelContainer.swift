//
//  ShareExtensionModelContainer.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 22/01/2025.
//

import SwiftData
import UIKit
import ShareJobFramework

class ShareExtensionModelContainer {
    static let shared: ModelContainer = {
        guard let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.RuiSilva.Jobs") else {
            fatalError("Failed to locate App Group directory.")
        }

        let storeURL = sharedURL.appendingPathComponent("Jobs.sqlite")

        do {
            let configuration = ModelConfiguration(url: storeURL)
            return try ModelContainer(for: Job.self, InterviewQuestion.self, configurations: configuration)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}
