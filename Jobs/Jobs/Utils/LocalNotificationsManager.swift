//
//  NotificationManager.swift
//  Jobs
//
//  Created by Rui Silva on 06/11/2024.
//

import Foundation
import UserNotifications

public protocol NotificationManaging {
    func scheduleNotification(followUp: Bool, company: String, title: String, followUpDate: Date)
    func requestAuthNotifications(followUp: Bool)
    func scheduleNotification(company: String, title: String, followUpDate: Date)
}


public struct NotificationManager: NotificationManaging {
    public func scheduleNotification(followUp: Bool, company: String, title: String, followUpDate: Date) {
        if followUp {
            scheduleNotification(company: company, title: title, followUpDate: followUpDate)
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

    public func scheduleNotification(company: String, title: String, followUpDate: Date) {
        let content = UNMutableNotificationContent()

        content.title = "Jobs: \(title) at \(company)"
        content.body = "Have you followed up on your job application?"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: followUpDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
