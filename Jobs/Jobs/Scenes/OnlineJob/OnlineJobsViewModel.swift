//
//  OnlineJobsViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 20/01/2025.
//

import Foundation
import Factory

class OnlineJobsViewModel: ObservableObject {
    
    @Published var onlineJobs: [OnlineJob] = []
    @Published var errorMessage: String = ""
    @Published var isShowingAlert: Bool = false
    
    @Injected(\.networkManager) private var networkManager
    
    @MainActor
    func fetchJobs(query: String) async {
        do {
            onlineJobs = try await networkManager.fetchOnlineJobs(query: "ios").hits
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
