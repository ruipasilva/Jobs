//
//  NewJobViewModel.swift
//  JobsTests
//
//  Created by Rui Silva on 13/11/2024.
//

import XCTest
import Factory
import SwiftData
@testable import Jobs

final class NewJobViewModelTests: XCTestCase {
    
    private let sut = NewJobViewModel()
    
    private let testJob = Job(title: "Title",
                          company: "Company",
                          notes: "Notes",
                          jobApplicationStatus: .notApplied,
                          jobApplicationStatusPrivate: "Status",
                          salary: "Salary",
                          location: "Location",
                          recruiterName: "RecruiterName",
                          recruiterNumber: "RecruiterNumber",
                          recruiterEmail: "RecruiterEmail",
                          followUp: false,
                          addToCalendar: false,
                          isEventAllDay: false,
                          jobURLPosting: "URL",
                          logoURL: "LogoURL",
                          companyWebsite: "CompanyURL",
                          workingDays: [],
                          currencyType: .Euro)
    
    
    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }
    
    @MainActor func test_WhenSaveJob_ThenSaveJob() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Job.self, configurations: configuration)
        let context = container.mainContext
    
        sut.saveJob(context: context)
        
        XCTAssertEqual(context.insertedModelsArray.count, 1)
        
    }
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    
}
