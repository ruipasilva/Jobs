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
    
    @State private var isShowingPasteLink = false
    @State private var isShowingRecruiterDetails = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Text(company)
                        .font(.title)
                    Text(title)
                        .font(.body)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                    Form {
                        Section {
                            Picker("Status", selection: $jobApplicationStatus) {
                                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                                    Text(status.status).tag(status)
                                }
                            }
                        }
                        
                        Section {
                            Picker("Location", selection: $locationType.animation()) {
                                ForEach(LocationType.allCases, id: \.self) { type in
                                    Text(type.type).tag(type)
                                }
                            }
                            if locationType == .onSite  || locationType == .hybrid {
                                TextField("Add Location", text: $location)
                            }
                            HStack {
                                Text("Salary")
                                Spacer()
                                TextField("Amount", text: $salary)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                            }
                            HStack {
                                Text("Job Posting")
                                    .onTapGesture {
                                        withAnimation {
                                            isShowingPasteLink.toggle()
                                        }
                                    }
                                Spacer()
                                Button {
                                } label: {
                                    Image(systemName: "arrow.up.forward.app.fill")
                                        .imageScale(.large)
                                        .tint(.accentColor)
                                }
                                .disabled(url.isEmpty)
                            }
                            
                            if isShowingPasteLink {
                                TextField("Paste link", text: $url)
                            }
                        }
                        
                        Section {
                            HStack {
                                Button(action: {
                                    withAnimation {
                                        isShowingRecruiterDetails.toggle()
                                    }
                                }, label: {
                                    Image(systemName: isShowingRecruiterDetails ? "menubar.arrow.up.rectangle" : "menubar.arrow.down.rectangle")
                                        .imageScale(.small)
                                })
                                
                                TextField("Recruiter's name", text: $recruiterName)
                                Spacer()
                                Image(systemName: "phone.circle.fill")
                                    .foregroundStyle(Color.accentColor)
                                    .imageScale(.large)
                                    .disabled(recruiterNumber.isEmpty)
                                Image(systemName: "envelope.circle.fill")
                                    .foregroundStyle(Color.accentColor)
                                    .imageScale(.large)
                                    .disabled(recruiterEmail.isEmpty)
                            }
                            if isShowingRecruiterDetails {
                                TextField("Phone number", text: $recruiterNumber)
                                    .keyboardType(.numberPad)
                                TextField("Email", text: $recruiterEmail)
                                    .keyboardType(.emailAddress)
                            }
                            
                        }
                        
                        Section {
                            TextField("Notes", text: $notes, axis: .vertical)
                                .lineLimit(5...10)
                        } header: {
                            Text("Your notes")
                        }
                    }
                    .frame(height: geo.size.height)
                    
                    //                    .scrollContentBackground(.visible)
                    .toolbar {
                        toolbarTrailing
                    }
                }
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        
        .onAppear {
            setProperties()
        }
    }
    
    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Update") {
                job.title = title
                job.company = company
                job.jobApplicationStatus = jobApplicationStatus
                job.location = location
                job.locationType = locationType
                job.salary = salary
                followUp = followUp
                followUpDate = followUpDate
                addInterviewToCalendar = addInterviewToCalendar
                addInterviewToCalendarDate = addInterviewToCalendarDate
                isEventAllDay = isEventAllDay
                job.recruiterName = recruiterName
                job.recruiterEmail = recruiterEmail
                job.recruiterNumber = recruiterNumber
                job.jobURLPosting = url
                job.notes = notes
                dismiss()
            }
        }
    }
    
    private func setProperties() {
        title = job.title
        company = job.company
        jobApplicationStatus = job.jobApplicationStatus
        location = job.location
        locationType = job.locationType
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
