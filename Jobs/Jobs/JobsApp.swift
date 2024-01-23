//
//  JobsApp.swift
//  Jobs
//
//  Created by Rui Silva on 22/01/2024.
//

import SwiftUI
import SwiftData

@main
struct JobsApp: App {
    let container: ModelContainer
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(container)
    }
    
    init() {
        let schema = Schema([Job.self])
        let config = ModelConfiguration("MyJobs", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure container - try uninstalling the app if issues occur")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
