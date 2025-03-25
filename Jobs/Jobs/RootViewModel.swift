//
//  RootViewModelViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 07/03/2025.
//

import Foundation
import Factory

class RootViewModel: ObservableObject {
    @Injected(\.keychainManager) var keychainManager
    @Injected(\.networkManager) var networkManager
    
    init() {
        Task {
            await loadAccessSecrets()
        }
    }
    
    @MainActor
    func loadAccessSecrets() async {
        do {
            let token = try await networkManager.fetchAccessToken()
            let apiKey = try await networkManager.fetchAPIKey()
            keychainManager.saveToken(token)
            keychainManager.saveAPIKey(apiKey)
        } catch {
            print("Error loading access secrets: \(error.localizedDescription)")
        }
    }
}
