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

    private let container: ModelContainer
    
    let appGroupID = "group.com.RuiSilva.Jobs"

    var body: some Scene {
        WindowGroup {
            TabViewRoot()
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault),
                    ])
                }
                .onOpenURL { url in
                    if url.scheme == "myapp" {
                        print("Test")
                    }
                }
        }
        .modelContainer(container)
    }

    init() {
        do {
            let config = ModelConfiguration(for: Job.self, InterviewQuestion.self)
            container = try ModelContainer(for: Job.self, InterviewQuestion.self, configurations: config)
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
