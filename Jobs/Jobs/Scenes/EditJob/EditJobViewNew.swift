//
//  EditJobViewNew.swift
//  Jobs
//
//  Created by Rui Silva on 01/08/2025.
//

import SwiftUI
import TipKit

struct EditJobViewNew: View {
    @StateObject private var editJobViewModel: EditJobViewModel
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    private var job: Job
    
    //    let interviewString = """WE’LL ANALYSE YOUR PROFILE AGAINST THE JOB DESCRIPTION AND HELP YOU PREPARE THE INTERVIEW"""
    
    public init(job: Job) {
        self._editJobViewModel = .init(wrappedValue: .init(job: job))
        self.job = job
    }
    
    var body: some View {
        List {
            Section {
                VStack {
                    imageView
                    tipView
                    titleView
                }
                .listRowBackground(Color.clear)
            }
            ApplicationStatusView(applicationStatus: $editJobViewModel.job.jobApplicationStatus,
                                  aplicationStatusPrivate: $editJobViewModel.job.jobApplicationStatusPrivate,
                                  appliedDate: $editJobViewModel.job.appliedDate) {
                editJobViewModel.setApplicationDate()
            }
            LocationTypeView(locationType: $editJobViewModel.job.locationType,
                             location: $editJobViewModel.job.location,
                             workingDays: $editJobViewModel.job.workingDays,
                             workingDaysToSave: editJobViewModel.workingDaysToSave)
            extraInfoView
            recruiterInfoView
            notesView
        }
        .toolbar(content: {
            toolbarTrailing
        })
        .sheet(isPresented: $editJobViewModel.isShowingLogoDetails) {
            LogoOptionsView(logoOptionsViewModel: editJobViewModel.getLogoOptionsViewModel())
        }
        .sheet(isPresented: $editJobViewModel.isShowingPrepareInterview) {
            Text("Interview preparation")
        }
        .alert("Important Notice", isPresented: $editJobViewModel.isShowingWarnings) {
            Button("Go!", role: .none) {
                openURL(URL(string: "https://www.\(editJobViewModel.job.companyWebsite)")!)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Websites might not be accurate. You can edit them by tapping the logo above")
        }
        .alert("Delete Job?", isPresented: $editJobViewModel.isShowingDeleteAlert) {
            Button("Delete", role: .destructive) {
                context.delete(editJobViewModel.job)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear(perform: {
            editJobViewModel.initialCompanyName = editJobViewModel.job.company
            editJobViewModel.initialJobTitle = editJobViewModel.job.title
        })
        .task(id: job) {
            do {
                try context.save()
            } catch {
                print("Failed to save")
            }
        }
        .onDisappear {
            if editJobViewModel.job.company.isEmpty || editJobViewModel.job.title.isEmpty {
                editJobViewModel.job.company = editJobViewModel.initialCompanyName
                editJobViewModel.job.title = editJobViewModel.initialJobTitle
            }
        }
    }
    
    private var imageView: some View {
        ZStack(alignment: .bottomTrailing) {
            
            CachedImage(url: editJobViewModel.job.logoURL, defaultLogoSize: 164)
                .padding(.top, 10)
                .frame(width: 164, height: 164)
            
            editLogoButton
        }
        .onTapGesture {
            editJobViewModel.isShowingLogoDetails = true
        }
    }
    
    private var tipView: some View {
        TipView(editJobViewModel.editTip, arrowEdge: .top)
            .tipBackground(Color(uiColor: .secondarySystemGroupedBackground))
            .padding(.horizontal)
    }
    
    private var editLogoButton: some View {
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .symbolRenderingMode(.palette)
                .frame(width: 30, height: 30)
                .foregroundStyle(.white, Color(uiColor: .systemGray))
                .padding(.bottom, 6)
                .padding(.trailing, 7)
    }
    
    private var titleView: some View {
        VStack {
            TextField("Company Name (required)", text: $editJobViewModel.job.company)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .font(.title)
            TextField("Job Title (required)", text: $editJobViewModel.job.title)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundStyle(Color(UIColor.secondaryLabel))
            
            HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "safari")
                        .imageScale(.small)
                    Text("Company Website")
                        .font(.subheadline)
                }
                .foregroundColor(.accentColor)
                .disabled(editJobViewModel.job.companyWebsite.isEmpty)
                .onTapGesture {
                    if editJobViewModel.count < 1 {
                        editJobViewModel.setupWebsiteWarning()
                    } else {
                        openURL(URL(string: "https://www.\(editJobViewModel.job.companyWebsite)")!)
                    }
                }
        }
    }
    
    private var extraInfoView: some View {
        Section {
            HStack {
                Text("Salary")
                Menu {
                    Picker("currency", selection: $editJobViewModel.job.currencyType) {
                        ForEach(CurrencyType.allCases) {
                            Text($0.symbol)
                        }
                    }
                } label: {
                    Text(editJobViewModel.job.currencyType.symbol)
                }
                Spacer()
                TextField("Amount", text: $editJobViewModel.job.salary)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            HStack {
                TextfieldWithSFSymbol(text: $editJobViewModel.job.jobURLPosting, placeholder: "URL", systemName: "info.circle")
                    .textCase(.lowercase)
                    .autocapitalization(.none)
                Spacer()
                Button(action: {
                    openURL(URL(string: editJobViewModel.job.jobURLPosting)!)
                }, label: {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color.accentColor)
                })
                .disabled(editJobViewModel.job.jobURLPosting.isEmpty)
                .buttonStyle(.plain)
            }
        }
    }
    
    private var recruiterInfoView: some View {
        Section {
            HStack {
                TextfieldWithSFSymbol(text: $editJobViewModel.job.recruiterName, placeholder: "Recruiter's Name", systemName: "person")
                Spacer()
                Button(action: {
                    editJobViewModel.makePhoneCall(phoneNumber: editJobViewModel.job.recruiterNumber)
                }, label: {
                    Image(systemName: "phone.circle.fill")
                        .foregroundStyle(Color.accentColor)
                        .imageScale(.large)
                })
                .disabled(editJobViewModel.job.recruiterNumber.isEmpty)
                
                Button(action: {
                    EmailHelper
                        .shared
                        .askUserForTheirPreference(
                            email: editJobViewModel.job.recruiterEmail,
                            subject:
                                "Interview at \(editJobViewModel.job.company) follow up",
                            body:
                                "Hi, \(editJobViewModel.job.recruiterName)")
                },label: {
                    Image(systemName: "envelope.circle.fill")
                        .foregroundStyle(Color.accentColor)
                        .imageScale(.large)
                })
                .disabled(editJobViewModel.job.recruiterEmail.isEmpty)
            }
            TextfieldWithSFSymbol(text: $editJobViewModel.job.recruiterEmail, placeholder: "Email", systemName: "envelope")
                .keyboardType(.emailAddress)
            TextfieldWithSFSymbol(text: $editJobViewModel.job.recruiterNumber, placeholder: "Phone Number", systemName: "phone")
                .keyboardType(.numberPad)
        }
    }
    
    private var notesView: some View {
        Section("Notes") {
            TextEditor(text: $editJobViewModel.job.notes)
                .lineLimit(10)
        }
    }
    
    @ToolbarContentBuilder private var toolbarTrailing: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            
            Button {
                editJobViewModel.isShowingPrepareInterview = true
            } label: {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .foregroundStyle(Color.blue)
            }
            
            Button {
                editJobViewModel.isShowingDeleteAlert = true
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(Color.red)
            }
            
            
           
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
