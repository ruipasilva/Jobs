//
//  NotificationManager.swift
//  Jobs
//
//  Created by Rui Silva on 06/11/2024.
//

import Foundation
import UserNotifications

public protocol NotificationManaging {
    func scheduleNotification(followUp: Bool, company: String, title: String, followUpDate: Date, id: String)
    func requestAuthNotifications(followUp: Bool)
}


public struct NotificationManager: NotificationManaging {
    public func scheduleNotification(followUp: Bool, company: String, title: String, followUpDate: Date, id: String) {
        if followUp {
            let content = UNMutableNotificationContent()

            content.title = "Jobs: \(title) at \(company)"
            content.body = "Have you followed up on your job application?"
            content.sound = UNNotificationSound.default
            
            let triggerDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: followUpDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    public func requestAuthNotifications(followUp: Bool) {
        if followUp {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
                if success {
                    print("All Set For Notifications")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
