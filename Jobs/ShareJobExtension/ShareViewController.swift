//
//  ShareViewController.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 21/01/2025.
//

import UIKit
import SwiftUI
import SwiftData

class ShareViewController: UIViewController {
    
    private var modelContext: ModelContext?
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extractURLFromContext()
        setupView()
        
    }
    
    func setupView() {
        let contentView = ShareExtensionView(action: { self.dismissShareExtension() })
            .environment(\.modelContext, modelContext!)
        let hostingController = UIHostingController(rootView: contentView)
        self.addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    private func extractURLFromContext() {
        modelContext = ShareExtensionModelContainer.shared.mainContext
        
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            print("No extension items found")
            return
        }
        
        for item in extensionItems {
            if let attachments = item.attachments {
                for attachment in attachments {
                    if attachment.hasItemConformingToTypeIdentifier("public.url") {
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
