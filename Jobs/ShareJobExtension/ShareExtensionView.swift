//
//  ShareExtensionView.swift
//  ShareJobExtension
//
//  Created by Rui Silva on 22/01/2025.
//

import SwiftUI
import SwiftData

struct ShareExtensionView: View {
    @Environment(\.modelContext) var container
    @FocusState private var focusState: FocusedField?
    @StateObject var shareExtensionViewModel = ShareExtensionViewModel()
    
    var action: () -> Void
    
    var body: some View {
        
        NavigationStack {
            Form {
                mainInfoView
                statusView
                jobPostingInfoView
            }
            .toolbar {
                toolbarTrailing
            }
            .navigationTitle("NewJob")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadSharedContent()
        }
    }
    
    private var mainInfoView: some View {
        Section {
            FloatingTextField(title: "Company Name", text: $shareExtensionViewModel.company, image: "building.2")
                .submitLabel(.next)
                .focused($focusState, equals: .companyName)
                .onChange(of: shareExtensionViewModel.company) { _, _ in
                    shareExtensionViewModel.handleTyping()
                }
                .onSubmit {
                    focusState = .jobTitle
                }
            FloatingTextField(title: "Job Title", text: $shareExtensionViewModel.title, image: "person")
                .focused($focusState, equals: .jobTitle)
                .onSubmit {
                    focusState = .notes
                }
        } header: {
            Text("Main Info")
        }
    }
    
    private var statusView: some View {
        Section {
            Picker("Status", selection: $shareExtensionViewModel.jobApplicationStatus) {
                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                    Text(status.status).tag(status)
                }
            }
        } header: {
            Text("Job Application Status")
        }
    }
    
    private var jobPostingInfoView: some View {
        Section {
            FloatingTextField(title: "Job Posting URL",
                              text: (shareExtensionViewModel.sharedText.isEmpty ? urlBinding : .constant("No URL found")),
                              image: "person")
        } header: {
            Text("Job Posting Info")
        }
    }
    
    private func loadSharedContent() {
        if let sharedDefaults = UserDefaults(suiteName: shareExtensionViewModel.appGroupID) {
            if let urlString = sharedDefaults.string(forKey: "url"), let url = URL(string: urlString) {
                shareExtensionViewModel.sharedURL = url
                sharedDefaults.removeObject(forKey: "url")
            }
        }
    }
    
    private var urlBinding: Binding<String> {
        Binding<String>(
            get: {
                shareExtensionViewModel.sharedURL?.absoluteString ?? ""
            },
            set: { newValue in
                shareExtensionViewModel.sharedURL = URL(string: newValue)
            }
        )
    }
    
    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Save") {
                shareExtensionViewModel.saveJob(context: container)
                action()
            }
            .disabled(shareExtensionViewModel.isTitleOrCompanyEmpty())
        }
    }
}
