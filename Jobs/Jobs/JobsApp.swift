//
//  JobsApp.swift
//  Jobs
//
//  Created by Rui Silva on 22/01/2024.
//

import SwiftData
import TipKit

@main
struct JobsApp: App {

    public let container: ModelContainer
    
    let appGroupID = "group.com.RuiSilva.Jobs"

    public var body: some Scene {
        WindowGroup {
            TabViewRoot()
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault),
                    ])
                }
        }
        .modelContainer(container)
    }

    public init() {
        
        guard let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
                    fatalError("Failed to get the App Group container URL.")
                }

                let storeURL = sharedURL.appendingPathComponent("Jobs.sqlite")
        
        do {
            let config = ModelConfiguration(url: storeURL)
            
            container = try ModelContainer(for: Job.self, configurations: config)

        } catch {
            fatalError("Could not configure container - try uninstalling the app if issues occur")
        }
    }
    
    func retrieveSharedURL() -> URL? {
        if let sharedDefaults = UserDefaults(suiteName: appGroupID),
           let urlString = sharedDefaults.string(forKey: "sharedURL") {
            return URL(string: urlString)
        }
        return nil
    }
}
