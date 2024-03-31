//
//  EmailHelper.swift
//  Jobs
//
//  Created by Rui Silva on 31/03/2024.
//

import SwiftUI
import MessageUI

class EmailHelper: NSObject {
    static let shared = EmailHelper()
    private override init() {}
}

extension EmailHelper {
    func askUserForTheirPreference(email: String, subject: String, body: String) {
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: "Pick your favourite email app", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Mail", style: .default) { action in
            self.open(presentingViewController, .applemail, email: email, subject: subject, body: body)
        })
        alertController.addAction(UIAlertAction(title: "Gmail", style: .default) { action in
            self.open(presentingViewController, .googlemail, email: email, subject: subject, body: body)
        })
        alertController.addAction(UIAlertAction(title: "Microsoft Outlook", style: .default) { action in
            self.open(presentingViewController, .outlook, email: email, subject: subject, body: body)
        })
        alertController.addAction(UIAlertAction(title: "Yahoo Mail", style: .default) { action in
            self.open(presentingViewController, .yahooMail, email: email, subject: subject, body: body)
        })
        alertController.addAction(UIAlertAction(title: "Spark", style: .default) { action in
            self.open(presentingViewController, .spark, email: email, subject: subject, body: body)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        presentingViewController.present(alertController, animated: true)
    }
    
    func open(_ presentingViewController: UIViewController,
              _ appType: AppType,
              email: String,
              subject: String,
              body: String) {
        
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let appleMail = URL(string: "mailto:\(email)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let gmailUrl = URL(string: "googlegmail://co?to=\(email)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(email)&subject=\(subjectEncoded)")
        let yahooUrl = URL(string: "ymail://mail/compose?to=\(email)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(email)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        switch appType {
        case .applemail: UIApplication.shared.open(appleMail!, completionHandler: { self.handleAppOpenCompletion(presentingViewController, $0, appName: "Mail") })
        case .googlemail: UIApplication.shared.open(gmailUrl!, completionHandler: { self.handleAppOpenCompletion(presentingViewController, $0, appName: "Gmail") })
        case .outlook: UIApplication.shared.open(outlookUrl!, completionHandler: { self.handleAppOpenCompletion(presentingViewController, $0, appName: "Microsoft Outlook") })
        case .yahooMail: UIApplication.shared.open(yahooUrl!, completionHandler: { self.handleAppOpenCompletion(presentingViewController, $0, appName: "Yahoo Mail") })
        case .spark: UIApplication.shared.open(sparkUrl!, completionHandler: { self.handleAppOpenCompletion(presentingViewController, $0, appName: "Spark") })
        }
    }
    
    private func handleAppOpenCompletion(_ presentingViewController: UIViewController,
                                         _ isSuccess: Bool,
                                         appName: String) {
        guard isSuccess else {
            let alertController = UIAlertController(title: nil, message: "You must install \(appName) first", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            presentingViewController.present(alertController, animated: true)
            return
        }
    }
    
    enum AppType {
        case applemail, googlemail, outlook, yahooMail, spark
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension EmailHelper: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
