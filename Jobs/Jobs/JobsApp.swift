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
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: Job.self)
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
