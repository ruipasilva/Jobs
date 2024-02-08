//
//  NewJobView.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI

struct NewJobView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var appViewModel: AppViewModel
    @FocusState private var focusState: Bool
    
    @State private var title = ""
    @State private var company = ""
    @State private var jobApplicationStatus = JobApplicationStatus.notApplied
    @State private var location: String = ""
    @State private var locationType = LocationType.remote
    @State private var salary = ""
    @State private var followUp = false
    @State private var followUpDate = Date.now
    @State private var addInterviewToCalendar = false
    @State private var addInterviewToCalendarDate = Date.now
    @State private var isEventAllDay = false
    @State private var recruiterName = ""
    @State private var recruiterEmail = ""
    @State private var recruiterNumber = ""
    @State private var url = ""
    @State private var notes = ""
    
    public init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        NavigationStack {
            Form {
                FloatingTextField(title: "Company Name", text: $company, image: "building.2")
                    .submitLabel(.continue)
                    .focused($focusState)
                FloatingTextField(title: "Job Title", text: $title, image: "person")
                    .focused($focusState)
                
                Section {
                    Picker("Status", selection: $jobApplicationStatus) {
                        ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                            Text(status.status).tag(status)
                        }
                    }
                } header: {
                    Text("Job Application Status")
                }
                
                Section {
                    Picker("Job Type", selection: $locationType.animation()) {
                        ForEach(LocationType.allCases, id: \.self) { location in
                            Text(location.type).tag(location)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if locationType == .onSite  || locationType == .hybrid {
                        FloatingTextField(title: "Location", text: $location, image: "mappin")
                    }
                } header: {
                    Text("Location")
                }
                
                Section {
                    Toggle("Follow up", isOn: $followUp.animation())
                    
                    if followUp {
                        DatePicker(
                            selection: $followUpDate,
                            in: Date.now ... Date.distantFuture,
                            displayedComponents: [.date]
                        ) {
                            Text("Reminder:")
                        }
                    }
                                        
                    Toggle("Add Interview To Calendar", isOn: $addInterviewToCalendar.animation())
                    
                    if addInterviewToCalendar {
                        Toggle(isOn: $isEventAllDay) {
                            Text("All day")
                        }
                        DatePicker(
                            selection: $addInterviewToCalendarDate,
                            in: Date.now...,
                            displayedComponents: isEventAllDay ? .date : [.date, .hourAndMinute]
                        ) {
                            Text("Date:")
                        }
                    }
                } header: {
                    Text("Reminders")
                } footer: {
                    Text("A Follow up will send a local notification to your device. Adding to calendar will create an event in the Calendar app.")
                }

                Section {
                    FloatingTextField(title: "Name", text: $recruiterName, image: "person.circle")
                        .keyboardType(.namePhonePad)
                    FloatingTextField(title: "Email", text: $recruiterEmail, image: "envelope")
                        .keyboardType(.emailAddress)
                    FloatingTextField(title: "Number", text: $recruiterNumber, image: "phone")
                        .keyboardType(.numberPad)
                } header: {
                    Text("Contacts")
                }

                
                
                Section {
                    FloatingTextField(title: "Salary", text: $salary, image: "creditcard")
                        .keyboardType(.numberPad)
                    FloatingTextField(title: "URL", text: $url, image: "link")
                } header: {
                    Text("Extra Info")
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let newJob = Job(title: title,
                                         company: company,
                                         dateAdded: Date.now,
                                         notes: notes,
                                         jobApplicationStatus: jobApplicationStatus,
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
                                         isEventAllDay: addInterviewToCalendar ? isEventAllDay : false,
                                         jobURLPosting: url
                        )
                        context.insert(newJob)
                        dismiss()
                    }
                    .disabled(title.isEmpty || company.isEmpty)
                }
            }
        }
    }
}

public enum TextfieldFocusState{
    case title, company
}
