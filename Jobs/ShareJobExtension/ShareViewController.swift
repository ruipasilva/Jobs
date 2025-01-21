//
//  ShareViewController.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 21/01/2025.
//

import UIKit
import SwiftUI
import Social

class ShareViewController: UIViewController {
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentView = ShareView()
                let hostingController = UIHostingController(rootView: contentView)
                addChild(hostingController)
                hostingController.view.frame = view.bounds
                view.addSubview(hostingController.view)
                hostingController.didMove(toParent: self)
    }
    
    private func saveSharedURL(_ url: URL) {
        // Save the URL to the shared UserDefaults
        if let sharedDefaults = UserDefaults(suiteName: appGroupID) {
            sharedDefaults.set(url.absoluteString, forKey: "sharedURL")
            sharedDefaults.synchronize() // Write immediately
            
            print("Shared URL saved: \(url.absoluteString)")
        }
        
        // Complete the request to dismiss the share sheet
        completeRequest()
    }
    
    private func completeRequest() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

struct ShareView: View {
    var body: some View {
        VStack {
            Text("Share Extension")
                .font(.headline)
                .padding()
            Spacer()
        }
    }
}
