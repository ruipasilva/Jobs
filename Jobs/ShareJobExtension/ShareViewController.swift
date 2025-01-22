//
//  ShareViewController.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 21/01/2025.
//

import UIKit
import SwiftUI

class ShareViewController: UIViewController {
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extractURLFromContext()
        setupView()
        
    }
    
    func setupView() {
        let contentView = ShareView(action: { self.dismissShareExtension() })
        let hostingController = UIHostingController(rootView: contentView)
        self.addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    private func extractURLFromContext() {
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
                                self.saveToAppGroup(content: url.absoluteString, type: "url")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func saveToAppGroup(content: String, type: String) {
        let userDefaults = UserDefaults(suiteName: appGroupID)
        userDefaults?.set(content, forKey: type)
        userDefaults?.synchronize()
    }
    
    private func dismissShareExtension() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

struct ShareView: View {
    
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    var action: () -> Void
    
    @State private var sharedURL: URL?
    @State private var sharedText: String = ""
    
    
    var body: some View {
        VStack {
            Text("Share Extension")
                .font(.headline)
                .padding()
            Text(sharedText.isEmpty ? sharedURL?.absoluteString ?? "No URL shared" : sharedText)
            
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
        if let sharedDefaults = UserDefaults(suiteName: appGroupID) {
            if let urlString = sharedDefaults.string(forKey: "url"), let url = URL(string: urlString) {
                sharedURL = url
                sharedDefaults.removeObject(forKey: "url") // Clear after reading
            }
        }
    }
}
