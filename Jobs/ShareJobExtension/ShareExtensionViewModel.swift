//
//  ShareExtensionViewModel.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 22/01/2025.
//

import Foundation
import SwiftData
import Factory
import Combine

public class ShareExtensionViewModel: BaseViewModel {

    let appGroupID = "group.com.RuiSilva.Jobs"

    @Published public var sharedURL: URL?
    @Published public var sharedText: String = ""

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
