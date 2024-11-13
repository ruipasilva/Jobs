//
//  JobMock.swift
//  JobsTests
//
//  Created by Rui Silva on 13/11/2024.
//

import Foundation
@testable import Jobs

struct JobMock {
    static let testJob = Job(title: "Title",
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
}
