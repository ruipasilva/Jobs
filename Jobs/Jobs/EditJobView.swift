//
//  EditJobView.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI

struct EditJobView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    let job: Job
    
    @State private var title = ""
    @State private var company = ""
    @State private var jobApplicationStatus = JobApplicationStatus.notApplied
    @State private var location = ""
    @State private var locationType = LocationType.remote
    @State private var salary = ""
    @State private var followUp = false
    @State private var followUpDate = Date.distantPast
    @State private var addInterviewToCalendar = false
    @State private var addInterviewToCalendarDate = Date.distantPast
    @State private var isEventAllDay = false
    @State private var recruiterName = ""
    @State private var recruiterEmail = ""
    @State private var recruiterNumber = ""
    @State private var url = ""
    @State private var notes = ""
//
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Job Title", text: $title)
                TextField("Company Name", text: $company)
                HStack {
                    Text("Status")
                    Picker("Status", selection: $jobApplicationStatus) {
                        ForEach(JobApplicationStatus.allCases) { status in
                            Text(status.status).tag(status)
                        }
                    }
                }
            }
            .padding()
            .toolbar {
                Button("Update") {
                    job.title = title
                    job.company = company
                    job.jobApplicationStatus = jobApplicationStatus.rawValue
                    location = location
                    locationType = locationType
                    salary = salary
                    followUp = followUp
                    followUpDate = followUpDate
                    addInterviewToCalendar = addInterviewToCalendar
                    addInterviewToCalendarDate = addInterviewToCalendarDate
                    isEventAllDay = isEventAllDay
                    recruiterName = recruiterName
                    recruiterEmail = recruiterEmail
                    recruiterNumber = recruiterNumber
                    url = url
                    notes = notes
                    dismiss()
                }
            }
        }
        .onAppear {
            title = job.title
            company = job.company
            jobApplicationStatus = JobApplicationStatus(rawValue: job.jobApplicationStatus)!
            location = job.location
            locationType = LocationType(rawValue: job.locationType)!
            salary = job.salary
            followUp = job.followUp
            followUpDate = job.followUpDate
            addInterviewToCalendar = job.addToCalendar
            addInterviewToCalendarDate = job.addToCalendarDate
            isEventAllDay = job.isEventAllDay
            recruiterName = job.recruiterName
            recruiterEmail = job.recruiterEmail
            recruiterNumber = job.recruiterNumber
            url = job.jobURLPosting
            notes = job.notes
        }
    }
}
