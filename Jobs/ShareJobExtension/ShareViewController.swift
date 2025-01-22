//
//  ShareViewController.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 21/01/2025.
//

import UIKit
import SwiftUI
import Social
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    var stringToShare: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extractURLFromContext()
        
        setupView()
        
    }
    
    func setupView() {
        let contentView = ShareView()
        let hostingController = UIHostingController(rootView: contentView)
        self.addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    /// Extract the URL from the extension context
        private func extractURLFromContext() {
            // Access the input items from the extension context
            guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
                print("No extension items found")
                return
            }

            for item in extensionItems {
                if let attachments = item.attachments {
                    for attachment in attachments {
                        // Check if the item conforms to "public.url" type
                        if attachment.hasItemConformingToTypeIdentifier("public.url") {
                            // Load the URL
                            attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] (item, error) in
                                guard let self = self else { return }
                                if let error = error {
                                    print("Error loading item: \(error.localizedDescription)")
                                    return
                                }

                                if let url = item as? URL {
                                    print("Extracted URL: \(url.absoluteString)")
                                    self.handleExtractedURL(url)
                                }
                            }
                        }
                    }
                }
            }
        }

        private func handleExtractedURL(_ url: URL) {
            // Save to App Group for communication with the main app
            let userDefaults = UserDefaults(suiteName: appGroupID)
            userDefaults?.set(url.absoluteString, forKey: "sharedURL")
            userDefaults?.synchronize()

            // Dismiss the extension
            dismissShareExtension()
        }

        /// Complete the Share Extension workflow
        private func dismissShareExtension() {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    
    private func completeRequest() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

struct ShareView: View {
    
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    @Environment(\.dismiss) var dismiss
    
    @State private var sharedURL: URL?
    

    var body: some View {
        VStack {
            Text("Share Extension")
                .font(.headline)
                .padding()
            Text(sharedURL?.absoluteString ?? "No URL shared")
            
            Button("Dismiss", action: {
                dismiss()
            })
            Spacer()
        }
        .onAppear {
            loadSharedURL()
        }
    }
    
    private func loadSharedURL() {
        let userDefaults = UserDefaults(suiteName: appGroupID)
            if let urlString = userDefaults?.string(forKey: "sharedURL"),
               let url = URL(string: urlString) {
                sharedURL = url
                userDefaults?.removeObject(forKey: "sharedURL") // Clean up after reading
            }
        }
}
