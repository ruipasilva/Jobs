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
    @Environment(\.openURL) private var openURL
    
    private let job: Job
    
    public init(job: Job) {
        self.job = job
    }
    
    var body: some View {
        VStack {
            Group {
                imageView
                    .popoverTip(editJobViewModel.editTip, arrowEdge: .bottom)
                titleView
            }
            .onTapGesture {
                editJobViewModel.isShowingLogoDetails = true
            }
            formView
        }
        .sheet(isPresented: $editJobViewModel.isShowingLogoDetails) {
            LogoOptionsView(logoOptionsViewModel: editJobViewModel.getLogoOptionsViewModel(), job: job)
        }
        .alert("Important Notice", isPresented: $editJobViewModel.isShowingWarnings) {
            Button("Go!", role: .none) {
                openURL(URL(string: "https://www.\(editJobViewModel.companyWebsite)")!)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Sometimes websites are not accurate!")
        }
        .toolbar {
            toolbarTrailing
        }
        
        .background(Color(uiColor: .systemGroupedBackground))
        .onAppear {
            editJobViewModel.setProperties(job: job)
        }
    }
    
    private var imageView: some View {
        AsyncImage(url: URL(string: editJobViewModel.logoURL)) { phase in
            switch phase {
            case .empty:
                defaultImage
            case let .success(image):
                image
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.top, 10)
            case .failure(_):
                defaultImage
            @unknown default:
                defaultImage
            }
        }
        
    }
    
    private var defaultImage: some View {
        Image(systemName: "suitcase.fill")
            .resizable()
            .foregroundColor(.mint)
            .frame(width: 64, height: 64)
    }
    
    private var titleView: some View {
        VStack {
            Text(editJobViewModel.company)
                .font(.title)
            Text(editJobViewModel.title)
                .font(.body)
                .foregroundStyle(Color(UIColor.secondaryLabel))
            
            Button(action: {
                if editJobViewModel.count < 1 {
                    editJobViewModel.count += 1
                    editJobViewModel.isShowingWarnings = true
                } else {
                    openURL(URL(string: "https://www.\(editJobViewModel.companyWebsite)")!)
                }
            }, label: {
                Label("Visit website", systemImage: "safari")
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                    .disabled(editJobViewModel.companyWebsite.isEmpty)
            })
            .padding(.top, 6)
        }
    }
    
    private var formView: some View {
        Form {
            jobStatusView
            extraInfoView
            recruiterInfoView
            notesView
            interviewQuestionsView
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
                        EmailHelper
                            .shared
                            .askUserForTheirPreference(email: editJobViewModel.recruiterEmail,
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
        } header: {
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
    
    private var interviewQuestionsView: some View {
        Section {
            List {
                ForEach($editJobViewModel.interviewQuestion, id: \.self) { $question in
                    HStack {
                        Image(systemName: question.completed ? "checkmark.circle.fill" : "circle")
                            .symbolEffect(.bounce, value: question.completed ? question.completed : nil)
                            .foregroundStyle(question.completed ? .accent : .secondary)
                            .onTapGesture {
                                    $question.completed.wrappedValue.toggle()
                            }
                        TextField("Type your question...", text: $question.question)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let interviewQuestionID = editJobViewModel.interviewQuestion[index].persistentModelID
                        let interviewQuestion = context.model(for: interviewQuestionID)
                        context.delete(interviewQuestion)
                        editJobViewModel.interviewQuestion.remove(atOffsets: indexSet)
                    }
                }
            }
            Button {
                withAnimation {
                    let interviewQuestion = InterviewQuestion(completed: false, question: "")
                    editJobViewModel.interviewQuestion.append(interviewQuestion)
                }
            } label: {
                Label("Add New", systemImage: "plus")
            }
        } header: {
            Text("Interview Questions")
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
