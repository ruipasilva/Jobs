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
        let newJob = Job(localNotificationID: self.localNotificationID,
                         title: title,
                         company: company,
                         notes: notes,
                         jobApplicationStatus: jobApplicationStatus,
                         jobApplicationStatusPrivate: jobApplicationStatus.status,
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
        newJob.interviewQuestions = interviewQuestions
    }
    
    public func saveJob(context: ModelContext) {
        addNewJob(context: context)
        do {
            try context.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}
