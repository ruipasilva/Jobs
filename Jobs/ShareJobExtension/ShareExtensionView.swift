//
//  ShareExtensionView.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 22/01/2025.
//

import SwiftUI

struct ShareExtensionView: View {
    
    @StateObject var shareExtensionViewModel = ShareExtensionViewModel()
    
    var action: () -> Void

    
    var body: some View {
        VStack {
            Text("Share Extension")
                .font(.headline)
                .padding()
            Text(shareExtensionViewModel.sharedText.isEmpty ? shareExtensionViewModel.sharedURL?.absoluteString ?? "No URL shared" : shareExtensionViewModel.sharedText)
            
            Button("Dismiss", action: {
                action()
            })
            Spacer()
        }
        .onAppear {
            loadSharedContent()
        }
    }
    
    private func loadSharedContent() {
        if let sharedDefaults = UserDefaults(suiteName: shareExtensionViewModel.appGroupID) {
            if let urlString = sharedDefaults.string(forKey: "url"), let url = URL(string: urlString) {
                shareExtensionViewModel.sharedURL = url
                sharedDefaults.removeObject(forKey: "url") // Clear after reading
            }
        }
    }
}
