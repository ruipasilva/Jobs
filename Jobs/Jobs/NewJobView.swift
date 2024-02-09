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
                mainInfoView
                statusView
                locationView
                remindersView
                recruitersInfoView
                otherInfoView
                notesView
            }
            .navigationTitle("New Job")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: followUp) { _, _ in
                appViewModel.requestAuthNotifications(followUp: followUp)
            }
            .onChange(of: addInterviewToCalendar, { _, _ in
                Task {
                    await appViewModel.requestAuthCalendar(addInterviewToCalendar: addInterviewToCalendar)
                }
            })
            .toolbar {
                toolbarLeading
                toolbarTrailing
            }
        }
    }
    
    private var mainInfoView: some View {
        Section {
            FloatingTextField(title: "Company Name", text: $company, image: "building.2")
                .submitLabel(.continue)
                .focused($focusState)
            FloatingTextField(title: "Job Title", text: $title, image: "person")
                .focused($focusState)
        } header: {
            Text("Main Info")
        }
    }
    
    private var statusView: some View {
        Section {
            Picker("Status", selection: $jobApplicationStatus) {
                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                    Text(status.status).tag(status)
                }
            }
        } header: {
            Text("Job Application Status")
        }
    }
    
    private var locationView: some View {
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
    }
    
    private var remindersView: some View {
        Section {
            Toggle("Follow up", isOn: $followUp.animation())
            
            
            if followUp {
                DatePicker(
                    selection: $followUpDate,
                    displayedComponents: [.date, .hourAndMinute]
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
    }
    
    private var recruitersInfoView: some View {
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
    }
    
    private var otherInfoView: some View {
        Section {
            FloatingTextField(title: "Salary", text: $salary, image: "creditcard")
                .keyboardType(.numberPad)
            FloatingTextField(title: "URL", text: $url, image: "link")
        } header: {
            Text("Extra Info")
        }
    }
    
    private var notesView: some View {
        Section {
            TextField("Notes", text: $notes, axis: .vertical)
                .lineLimit(5...10)
        } header: {
            Text("Your notes")
        }
    }
    
    private var toolbarLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") {
                if appViewModel.isTitleOrCompanyEmpty(title: title, company: company) {
                    dismiss()
                } else {
                    appViewModel.showingCancelActionSheet = true
                }
            }.confirmationDialog(
                "Are you sure you want to discard this job?",
                isPresented: $appViewModel.showingCancelActionSheet,
                titleVisibility: .visible
            ) {
                Button(role: .destructive, action: {
                    dismiss()
                }) {
                    Text("Discard Job")
                }
            }
        }
    }
    
    private var toolbarTrailing: some ToolbarContent {
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
                
                appViewModel.scheduleNotification(followUp: followUp, company: company, title: title, followUpDate: followUpDate)
                
                appViewModel.scheduleCalendarEvent(addEventToCalendar: addInterviewToCalendar, eventAllDay: isEventAllDay, company: company, title: title, addToCalendarDate: addInterviewToCalendarDate)
                
                dismiss()
            }
            .disabled(appViewModel.isTitleOrCompanyEmpty(title: title, company: company))
        }
    }
}
