//
//  EditJobView.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI

struct EditJobView: View {
    @StateObject private var editJobViewModel = EditJobViewModel()
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    private let job: Job
    
    public init(job: Job) {
        self.job = job
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    titleView
                    formView
                        .frame(height: geo.size.height)
                        .toolbar {
                            toolbarTrailing
                        }
                }
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .onAppear {
            editJobViewModel.setProperties(job: job)
        }
    }
    
    private var titleView: some View {
        Group {
            Text(editJobViewModel.company)
                .font(.title)
            Text(editJobViewModel.title)
                .font(.body)
                .foregroundStyle(Color(UIColor.secondaryLabel))
        }
    }
    
    private var formView: some View {
        Form {
            jobStatusView
            extraInfoView
            recruiterInfoView
            notesView
        }
        
    }
    
    private var jobStatusView: some View {
        Section {
            Picker("Status", selection: $editJobViewModel.jobApplicationStatus) {
                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                    Text(status.status).tag(status)
                }
            }
        }
    }
    
    private var extraInfoView: some View {
        Section {
            Picker("Location", selection: $editJobViewModel.locationType.animation()) {
                ForEach(LocationType.allCases, id: \.self) { type in
                    Text(type.type).tag(type)
                }
            }
            if !editJobViewModel.isLocationRemote() {
                TextField("Add Location", text: $editJobViewModel.location)
            }
            HStack {
                Text("Salary")
                Spacer()
                TextField("Amount", text: $editJobViewModel.salary)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            HStack {
                Text("Job Posting")
                    .onTapGesture {
                        withAnimation {
                            editJobViewModel.isShowingJobLink()
                        }
                    }
                Spacer()
                Image(systemName: "arrow.up.forward.app.fill")
                    .imageScale(.large)
                    .foregroundStyle(Color.accentColor)
                    .onTapGesture {
                        // open job link
                    }
                    .disabled(editJobViewModel.url.isEmpty)
            }
            
            if editJobViewModel.isShowingPasteLink {
                TextField("Paste link", text: $editJobViewModel.url)
            }
        }
    }
    
    private var recruiterInfoView: some View {
        Section {
            HStack {
                Image(systemName: editJobViewModel.isShowingRecruiterDetails ? "menubar.arrow.up.rectangle" : "menubar.arrow.down.rectangle")
                    .imageScale(.small)
                    .foregroundStyle(Color.accentColor)
                    .onTapGesture {
                        withAnimation {
                            editJobViewModel.isShowingRecruiterDetails.toggle()
                        }
                    }
                
                TextField("Recruiter's name", text: $editJobViewModel.recruiterName)
                Spacer()
                Image(systemName: "phone.circle.fill")
                    .foregroundStyle(Color.accentColor)
                    .imageScale(.large)
                    .onTapGesture {
                        // Call recruiter
                    }
                    .disabled(editJobViewModel.recruiterNumber.isEmpty)
                
                
                Image(systemName: "envelope.circle.fill")
                    .foregroundStyle(Color.accentColor)
                    .imageScale(.large)
                    .onTapGesture {
                        EmailHelper.shared.askUserForTheirPreference(email: editJobViewModel.recruiterEmail,
                                                                     subject: "Interview at \(editJobViewModel.company) follow up",
                                                                     body: "Hi, \(editJobViewModel.recruiterName)")
                    }
                    .disabled(editJobViewModel.recruiterEmail.isEmpty)
            }
            if editJobViewModel.isShowingRecruiterDetails {
                TextField("Phone number", text: $editJobViewModel.recruiterNumber)
                    .keyboardType(.numberPad)
                TextField("Email", text: $editJobViewModel.recruiterEmail)
                    .keyboardType(.emailAddress)
            }
        }
    header: {
        Text("Recruiter Info")
    }
    }
    
    private var notesView: some View {
        Section {
            TextField("Notes", text: $editJobViewModel.notes, axis: .vertical)
                .lineLimit(5...10)
        } header: {
            Text("Your notes")
        }
    }
    
    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Update") {
                editJobViewModel.updateJob(job: job)
                dismiss()
            }
        }
    }
}
