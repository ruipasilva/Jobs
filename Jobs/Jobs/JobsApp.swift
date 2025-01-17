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

    var body: some Scene {
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

    init() {
        do {
            let config = ModelConfiguration(for: Job.self, InterviewQuestion.self)
            container = try ModelContainer(for: Job.self, InterviewQuestion.self, configurations: config)
        } catch {
            fatalError("Could not configure container - try uninstalling the app if issues occur")
        }
    }
}
