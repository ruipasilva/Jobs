//
//  EditJobView.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI
import TipKit

struct EditJobView: View {
    @StateObject private var editJobViewModel = EditJobViewModel()
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    @State private var showingSheet = false
    
    private let job: Job
    
    public init(job: Job) {
        self.job = job
    }
    
    var body: some View {
            ScrollView {
                LazyVStack {
                    Group {
                        imageView
                        tipView
                        titleView
                    }
                    .onTapGesture {
                        editJobViewModel.isShowingLogoDetails = true
                    }
                    statusView()
                    locationView()
                    extraInfoView()
                    recruiterInfoView()
                    notesViewFinal()
                    interviewQuestionsView()
                }
                .padding(.bottom)
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
            Text("Sometimes websites are not accurate. You can edit them by tapping the logo above")
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .onAppear {
            editJobViewModel.setProperties(job: job)
        }
        .toolbar {
            toolbarTrailing
        }
        
        /// Code to uncomment when work on maps functionality
        
//        .actionSheet(isPresented: $showingSheet) {
//                    let latitude = 45.5088
//                    let longitude = -73.554
//
//                    let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
//                    let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
//
//                    let googleItem = ("Google Map", URL(string:googleURL)!)
//                    var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
//
//                    if UIApplication.shared.canOpenURL(googleItem.1) {
//                        installedNavigationApps.append(googleItem)
//                    }
//                    
//                    var buttons: [ActionSheet.Button] = []
//                    for app in installedNavigationApps {
//                        let button: ActionSheet.Button = .default(Text(app.0)) {
//                            UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
//                        }
//                        buttons.append(button)
//                    }
//                    let cancel: ActionSheet.Button = .cancel()
//                    buttons.append(cancel)
//                    
//                    return ActionSheet(title: Text("Navigate"), message: Text("Select an app..."), buttons: buttons)
//                }
    }
    
    private var tipView: some View {
        TipView(editJobViewModel.editTip, arrowEdge: .top)
            .tipBackground(Color(uiColor: .secondarySystemGroupedBackground))
            .padding(.horizontal)
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
                    editJobViewModel.setupWebsiteWarning()
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
            .padding(.bottom, 32)
        }
    }
    
    private func statusView() -> some View {
        HStack {
            Text("Status")
                .padding(.leading)
            Spacer()
            Picker("Status", selection: $editJobViewModel.jobApplicationStatus) {
                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                    Text(status.status).tag(status)
                }
            }
        }
        .padding(.vertical, 6)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
    
    private func locationView() -> some View {
        VStack {
            HStack {
                Text("Location")
                    .padding(.leading)
                Spacer()
                Picker("Location", selection: $editJobViewModel.locationType.animation()) {
                    ForEach(LocationType.allCases, id: \.self) { type in
                        Text(type.type).tag(type)
                    }
                }
            }
            if !editJobViewModel.isLocationRemote() {
                Divider()
                TextField("Add Location", text: $editJobViewModel.location)
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                Divider()
                WorkingDaysView(workingDaysToSave: $editJobViewModel.workingDaysToSave, workingDays: editJobViewModel.workingDays)
                    .padding(.vertical, 6)
            }
        }
        .padding(.vertical, 6)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
    
    private func extraInfoView() -> some View {
        VStack {
            HStack {
                Text("Salary")
                Spacer()
                TextField("Amount", text: $editJobViewModel.salary)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            Divider()
            HStack {
                TextField("Link to job posting", text: $editJobViewModel.url)
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color.accentColor)
                })
                .disabled(editJobViewModel.url.isEmpty)
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
        .padding(.vertical, 6)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
    
    private func recruiterInfoView() -> some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        editJobViewModel.isShowingRecruiterDetails.toggle()
                    }
                }, label: {
                    Image(systemName: "info.circle")
                        .imageScale(.medium)
                        .foregroundStyle(Color.accentColor)
                })
                .buttonStyle(.plain)
                
                TextField("Recruiter's name", text: $editJobViewModel.recruiterName)
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "phone.circle.fill")
                        .foregroundStyle(Color.accentColor)
                        .imageScale(.large)
                })
                .disabled(editJobViewModel.recruiterNumber.isEmpty)
                
                Button(action: {
                    EmailHelper
                        .shared
                        .askUserForTheirPreference(email: editJobViewModel.recruiterEmail,
                                                   subject: "Interview at \(editJobViewModel.company) follow up",
                                                   body: "Hi, \(editJobViewModel.recruiterName)")
                }, label: {
                    Image(systemName: "envelope.circle.fill")
                        .foregroundStyle(Color.accentColor)
                        .imageScale(.large)
                })
                .buttonStyle(.plain)
                .disabled(editJobViewModel.recruiterEmail.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            
            if editJobViewModel.isShowingRecruiterDetails {
                Divider()
                TextField("Phone number", text: $editJobViewModel.recruiterNumber)
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                Divider()
                TextField("Email", text: $editJobViewModel.recruiterEmail)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
            }
        }
        .padding(.vertical, 6)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
    
    private func notesViewFinal() -> some View {
        TextField("Notes", text: $editJobViewModel.notes, axis: .vertical)
            .lineLimit(5...10)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
    }
    
    private func interviewQuestionsView() -> some View {
        VStack(alignment: .leading) {
            ForEach($editJobViewModel.interviewQuestion, id: \.id) { $question in
                HStack {
                    Image(systemName: question.completed ? "checkmark.circle.fill" : "circle")
                        .symbolEffect(.bounce, value: question.completed ? question.completed : nil)
                        .foregroundStyle(question.completed ? .accent : .secondary)
                        .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: question.completed)
                        .onTapGesture {
                            $question.completed.wrappedValue.toggle()
                        }
                    TextField("Type your question...", text: $question.question)
                    Spacer()
                    Button(action: {
                        editJobViewModel.interviewQuestion.removeAll { q in
                            q == question
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                Divider()
            }
            
            Button {
                withAnimation {
                    let interviewQuestion = InterviewQuestion(completed: false, question: "")
                    editJobViewModel.interviewQuestion.append(interviewQuestion)
                    
                }
            } label: {
                Label("Add New", systemImage: "plus")
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
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
