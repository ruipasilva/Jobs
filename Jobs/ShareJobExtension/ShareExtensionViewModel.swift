//
//  ShareExtensionViewModel.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 22/01/2025.
//

import Foundation
import SwiftData
import Factory

public class ShareExtensionViewModel: BaseViewModel {
    
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    @Published public var sharedURL: URL?
    @Published public var sharedText: String = ""
    
    private func addNewJob(context: ModelContext) {
        let newJob = Job(id: UUID(),
                         localNotificationID: localNotificationID,
                         title: title,
                         company: company,
                         notes: notes,
                         jobApplicationStatus: jobApplicationStatus,
                         jobApplicationStatusPrivate: jobApplicationStatus.status,
                         appliedDate: jobApplicationStatus == .notApplied ? nil : Date(),
                         salary: salary,
                         location: location,
                         locationType: locationType,
                         recruiterName: recruiterName,
                         recruiterNumber: recruiterNumber,
                         recruiterEmail: recruiterEmail,
                         followUp: followUp,
                         followUpDate: followUpDate,
                         addToCalendar: addInterviewToCalendar,
                         addToCalendarDate: addInterviewToCalendarDate,
                         isEventAllDay: isEventAllDay,
                         jobURLPosting: sharedText.isEmpty ? sharedURL?.absoluteString ?? "No URL shared" : sharedText,
                         logoURL: logoURL,
                         companyWebsite: companyWebsite,
                         workingDays: workingDaysToSave,
                         currencyType: currencyType)
        context.insert(newJob)
    }
    
    public func isTitleOrCompanyEmpty() -> Bool {
        return title.isEmpty || company.isEmpty
    }
    
    public func saveJob(context: ModelContext) {
        addNewJob(context: context)
        do {
            try context.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
    
    public func loadSharedContent() {
        if let sharedDefaults = UserDefaults(suiteName: appGroupID) {
            if let urlString = sharedDefaults.string(forKey: "url"), let url = URL(string: urlString) {
                sharedURL = url
                sharedDefaults.removeObject(forKey: "url")
            }
        }
    }
}
