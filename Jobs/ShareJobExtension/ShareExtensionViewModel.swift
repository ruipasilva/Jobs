//
//  ShareExtensionViewModel.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 22/01/2025.
//

import Foundation
import SwiftData
import Factory

public class ShareExtensionViewModel: ObservableObject {
    
    @Published public var localNotificationID = ""
    @Published public var title = ""
    @Published public var company = ""
    @Published public var applicationStatusPrivate = ""
    @Published public var jobApplicationStatus = JobApplicationStatus.notApplied
    @Published public var jobApplicationStatusPrivate = ""
    @Published public var location = ""
    @Published public var locationType = LocationType.remote
    @Published public var salary = ""
    @Published public var followUp = false
    @Published public var followUpDate = Date.distantPast
    @Published public var addInterviewToCalendar = false
    @Published public var addInterviewToCalendarDate = Date.distantPast
    @Published public var isEventAllDay = false
    @Published public var recruiterName = ""
    @Published public var recruiterEmail = ""
    @Published public var recruiterNumber = ""
    @Published public var url = ""
    @Published public var notes = ""
    @Published public var logoURL = ""
    @Published public var companyWebsite = ""
    @Published public var interviewQuestions: [InterviewQuestion] = []
    @Published public var workingDaysToSave: [String] = []
    @Published public var currencyType: CurrencyType = .dolar
    
    public let workingDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    let appGroupID = "group.com.RuiSilva.Jobs"
    
    @Published public var sharedURL: URL?
    @Published public var sharedText: String = ""
    
    @Injected(\.networkManager) var networkManager
    
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
