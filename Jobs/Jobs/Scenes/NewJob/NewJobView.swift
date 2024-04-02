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
    @StateObject private var newJobViewModel = NewJobViewModel()
    @FocusState private var focusState: Bool
    
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
            .onChange(of: newJobViewModel.followUp) { _, _ in
                newJobViewModel.requestAuthNotifications(followUp: newJobViewModel.followUp)
            }
            .onChange(of: newJobViewModel.addInterviewToCalendar, { _, _ in
                Task {
                    await newJobViewModel.requestAuthCalendar(addInterviewToCalendar: newJobViewModel.addInterviewToCalendar)
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
            FloatingTextField(title: "Company Name", text: $newJobViewModel.company, image: "building.2")
                .submitLabel(.continue)
                .focused($focusState)
            FloatingTextField(title: "Job Title", text: $newJobViewModel.title, image: "person")
                .focused($focusState)
        } header: {
            Text("Main Info")
        }
    }
    
    private var statusView: some View {
        Section {
            Picker("Status", selection: $newJobViewModel.jobApplicationStatus) {
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
            Picker("Job Type", selection: $newJobViewModel.locationType.animation()) {
                ForEach(LocationType.allCases, id: \.self) { location in
                    Text(location.type).tag(location)
                }
            }
            .pickerStyle(.segmented)
            
            if newJobViewModel.locationType == .onSite  || newJobViewModel.locationType == .hybrid {
                FloatingTextField(title: "Location", text: $newJobViewModel.location, image: "mappin")
            }
        } header: {
            Text("Location")
        }
    }
    
    private var remindersView: some View {
        Section {
            Toggle("Follow up", isOn: $newJobViewModel.followUp.animation())
            
            
            if newJobViewModel.followUp {
                DatePicker(
                    selection: $newJobViewModel.followUpDate,
                    displayedComponents: [.date, .hourAndMinute]
                ) {
                    Text("Reminder:")
                }
            }
            
            Toggle("Add Interview To Calendar", isOn: $newJobViewModel.addInterviewToCalendar.animation())
            
            if newJobViewModel.addInterviewToCalendar {
                Toggle(isOn: $newJobViewModel.isEventAllDay) {
                    Text("All day")
                }
                DatePicker(
                    selection: $newJobViewModel.addInterviewToCalendarDate,
                    in: Date.now...,
                    displayedComponents: newJobViewModel.isEventAllDay ? .date : [.date, .hourAndMinute]
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
            FloatingTextField(title: "Name", text: $newJobViewModel.recruiterName, image: "person.circle")
                .keyboardType(.namePhonePad)
            FloatingTextField(title: "Email", text: $newJobViewModel.recruiterEmail, image: "envelope")
                .keyboardType(.emailAddress)
            FloatingTextField(title: "Number", text: $newJobViewModel.recruiterNumber, image: "phone")
                .keyboardType(.numberPad)
        } header: {
            Text("Contacts")
        }
    }
    
    private var otherInfoView: some View {
        Section {
            FloatingTextField(title: "Salary", text: $newJobViewModel.salary, image: "creditcard")
                .keyboardType(.numberPad)
            FloatingTextField(title: "URL", text: $newJobViewModel.url, image: "link")
        } header: {
            Text("Extra Info")
        }
    }
    
    private var notesView: some View {
        Section {
            TextField("Notes", text: $newJobViewModel.notes, axis: .vertical)
                .lineLimit(5...10)
        } header: {
            Text("Your notes")
        }
    }
    
    private var toolbarLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") {
                if newJobViewModel.isTitleOrCompanyEmpty(title: newJobViewModel.title, company: newJobViewModel.company) {
                    dismiss()
                } else {
                    newJobViewModel.showingCancelActionSheet = true
                }
            }.confirmationDialog(
                "Are you sure you want to discard this job?",
                isPresented: $newJobViewModel.showingCancelActionSheet,
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
                newJobViewModel.addNewJob(context: context)
                
                newJobViewModel.scheduleNotification(followUp: newJobViewModel.followUp, 
                                                     company: newJobViewModel.company,
                                                     title: newJobViewModel.title, 
                                                     followUpDate: newJobViewModel.followUpDate)
                
                newJobViewModel.scheduleCalendarEvent(addEventToCalendar: newJobViewModel.addInterviewToCalendar, 
                                                      eventAllDay: newJobViewModel.isEventAllDay,
                                                      company: newJobViewModel.company,
                                                      title: newJobViewModel.title,
                                                      addToCalendarDate: newJobViewModel.addInterviewToCalendarDate)
                
                dismiss()
            }
            .disabled(newJobViewModel.isTitleOrCompanyEmpty(title: newJobViewModel.title, company: newJobViewModel.company))
        }
    }
}