//
//  NewJobViewModel.swift
//  Jobs
//
//  Created by Rui Silva on 02/04/2024.
//

import EventKit
import Factory
import Foundation
import SwiftData
import UserNotifications
import Combine

public final class NewJobViewModel: BaseViewModel {

    @Injected(\.calendarManager) public var calendarManager
    @Injected(\.notificationManager) public var notificationManager
    @Injected(\.storageManager) public var storeManager

    private var cancellables = Set<AnyCancellable>()

    override public init() {
        super.init()

        // Debounce company input to avoid excessive API calls
        $company
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] companyName in
                guard let self = self else { return }
                Task { @MainActor in
                    try? await self.getLogo(company: companyName)
                }
            }
            .store(in: &cancellables)
    }
    
    public func showDiscardDialog() {
        showingCancelActionSheet = true
    }
    
    public func isTitleOrCompanyEmpty() -> Bool {
        return title.isEmpty || company.isEmpty
    }
    
    public func setApplicationDate() {
        if jobApplicationStatus == .notApplied {
            appliedDate = nil
        }
    }
    
    private func addNewJob(context: ModelContext) {
        let newJob = Job(id: UUID(),
                         localNotificationID: self.localNotificationID,
                         title: title,
                         company: company,
                         dateAdded: dateAdded,
                         notes: notes,
                         jobApplicationStatus: jobApplicationStatus,
                         jobApplicationStatusPrivate: jobApplicationStatus.status,
                         appliedDate: appliedDate,
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
                         jobURLPosting: jobURLPosting,
                         logoURL:  logoURL,
                         companyWebsite: companyWebsite,
                         workingDays: workingDays,
                         currencyType: currencyType)
        storeManager.save(context: context, job: newJob)
    }
    
    public func saveJob(context: ModelContext) {
        
        if followUp {
            notificationManager.scheduleNotification(
                company: company,
                title: title,
                followUpDate: followUpDate,
                id: &localNotificationID)
        }
        
        if addInterviewToCalendar {
            calendarManager.scheduleCalendarEvent(
                eventAllDay: isEventAllDay,
                company: company,
                title: title,
                addToCalendarDate: addInterviewToCalendarDate)
        }
        
        addNewJob(context: context)
        do {
            try context.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
    
}
