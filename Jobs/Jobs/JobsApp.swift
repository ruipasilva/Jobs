//
//  JobsApp.swift
//  Jobs
//
//  Created by Rui Silva on 22/01/2024.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct JobsApp: App {
    @StateObject private var appViewModel = AppViewModel()
    
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            TabViewRoot(appViewModel: appViewModel)
                .task {
                    try? Tips.configure([
                        .displayFrequency(.monthly),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            let config = ModelConfiguration(for: Job.self, InterviewQuestion.self)
//            let config2 = ModelConfiguration(for: InterviewQuestion.self)
            container = try ModelContainer(for: Job.self, InterviewQuestion.self, configurations: config)
        } catch {
            fatalError("Could not configure container - try uninstalling the app if issues occur")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
