//
//  NewJobView.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI

public struct NewJobView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var newJobViewModel = NewJobViewModel()
    @FocusState private var focusState: FocusedField?
    
    public var body: some View {
        NavigationStack {
            Form {
                mainInfoView
                ApplicationStatusView(applicationStatus: $newJobViewModel.jobApplicationStatus,
                                      aplicationStatusPrivate: $newJobViewModel.jobApplicationStatusPrivate,
                                      appliedDate: $newJobViewModel.appliedDate,
                                      onChange: { newJobViewModel.setApplicationDate() })
                
                LocationTypeView(locationType: $newJobViewModel.locationType,
                                 location: $newJobViewModel.location,
                                 workingDays: $newJobViewModel.workingDays,
                                 workingDaysToSave: newJobViewModel.workingDaysToSave)
                remindersView
                recruitersInfoView
                otherInfoView
                notesView
            }
            .background(Color(UIColor.systemGroupedBackground))
            .toolbar {
                toolbarLeading
                toolbarTrailing
            }
            .navigationTitle("New Job")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: newJobViewModel.followUp) { _, _ in
                newJobViewModel.notificationManager.requestNotificationAccess(followUp: newJobViewModel.followUp)
            }
            .onChange(of: newJobViewModel.addInterviewToCalendar) { _, _ in
                Task {
                    await newJobViewModel.calendarManager
                        .requestAuthCalendar(addInterviewToCalendar: newJobViewModel.addInterviewToCalendar)
                }
            }
        }
    }
    
    private var mainInfoView: some View {
        Section {
            TextfieldWithSFSymbol(text: $newJobViewModel.company, placeholder: "Company Name (required)", systemName: "building.2")
                .submitLabel(.next)
                .focused($focusState, equals: .companyName)
                .onChange(of: newJobViewModel.company) { _, _ in
                    newJobViewModel.handleTyping()
                }
                .onSubmit {
                    focusState = .jobTitle
                }
            TextfieldWithSFSymbol(text: $newJobViewModel.title, placeholder: "Job Title (required)", systemName: "person")
                .focused($focusState, equals: .jobTitle)
        }
    }
    
    private var remindersView: some View {
        Section {
            Toggle("Follow up", isOn: $newJobViewModel.followUp.animation())
            
            if newJobViewModel.followUp {
                DatePicker(selection: $newJobViewModel.followUpDate,
                           in: Date.now...,
                           displayedComponents: [.date, .hourAndMinute]) {
                    Text("Reminder:")
                }
            }
            
            Toggle("Add Interview To Calendar", isOn: $newJobViewModel.addInterviewToCalendar.animation())
            
            if newJobViewModel.addInterviewToCalendar {
                Toggle(isOn: $newJobViewModel.isEventAllDay) {
                    Text("All day")
                }
                DatePicker(selection: $newJobViewModel.addInterviewToCalendarDate,
                           in: Date.now...,
                           displayedComponents: newJobViewModel.isEventAllDay ? .date : [.date, .hourAndMinute]) {
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
            TextfieldWithSFSymbol(text: $newJobViewModel.recruiterName, placeholder: "Name", systemName: "person.circle")
                .keyboardType(.namePhonePad)
                .focused($focusState, equals: .recruiterName)
                .submitLabel(.next)
                .onSubmit {
                    focusState = .recruiterEmail
                }
            TextfieldWithSFSymbol(text: $newJobViewModel.recruiterEmail, placeholder: "Email", systemName: "envelope")
                .focused($focusState, equals: .recruiterEmail)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .onSubmit {
                    focusState = .recruiterNumber
                }
            TextfieldWithSFSymbol(text: $newJobViewModel.recruiterNumber, placeholder: "Number", systemName: "phone")
                .focused($focusState, equals: .recruiterNumber)
                .keyboardType(.numberPad)
            
        } header: {
            Text("Recruiter Information")
        }
    }
    
    private var otherInfoView: some View {
        Section {
            TextfieldWithSFSymbol(text: $newJobViewModel.salary, placeholder: "Salary", systemName: "creditcard")
                .keyboardType(.numberPad)
            TextfieldWithSFSymbol(text: $newJobViewModel.jobURLPosting, placeholder: "URL", systemName: "link")
                .submitLabel(.next)
                .onSubmit {
                    focusState = .notes
                }
        } header: {
            Text("Extra Information")
        }
    }
    
    private var notesView: some View {
        Section {
            TextField("Notes", text: $newJobViewModel.notes, axis: .vertical)
                .focused($focusState, equals: .notes)
                .lineLimit(5...10)
        }
        
    }
    
    private var toolbarLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") {
                if newJobViewModel.isTitleOrCompanyEmpty() {
                    dismiss()
                } else {
                    newJobViewModel.showDiscardDialog()
                }
            }
            .confirmationDialog("Are you sure you want to discard this job?",
                                isPresented: $newJobViewModel.showingCancelActionSheet,
                                titleVisibility: .visible) {
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
            Button {
                newJobViewModel.saveJob(context: context)
                dismiss()
            } label: {
                Text("Add")
                    .fontWeight(.semibold)
            }
            .disabled(newJobViewModel.isTitleOrCompanyEmpty())
        }
    }
}
