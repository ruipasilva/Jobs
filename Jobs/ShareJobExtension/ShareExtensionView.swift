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
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack {
                        mainInfoView
                        statusView
                        notesView
                    }
                }
                addButton
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Shortlist Job")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            shareExtensionViewModel.loadSharedContent()
            focusState = .companyName
        }
    }
    private var statusView: some View {
        HStack {
            Text("Application Status")
                .padding(.leading)
            Spacer()
            Picker("Status", selection: $shareExtensionViewModel.jobApplicationStatus) {
                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                    Text(status.status).tag(status)
                }
            }
        }
        .cellBackground()
        .tint(.mint)
    }
    
    private var mainInfoView: some View {
        VStack(spacing: .zero) {
            HStack {
                Image(systemName: "building.2")
                TextField("Company Name (required)", text: $shareExtensionViewModel.company)
            }
            .padding(.vertical, 4)
            .submitLabel(.next)
            .focused($focusState, equals: .companyName)
            .onChange(of: shareExtensionViewModel.company) { _, _ in
                shareExtensionViewModel.handleTyping()
            }
            .onSubmit {
                focusState = .jobTitle
            }
            .cellPadding()
            Divider()
            HStack {
                Image (systemName: "person")
                TextField("Job Title (required)", text: $shareExtensionViewModel.title)
                
            }
            .padding(.vertical, 4)
            .submitLabel(.return)
            .focused($focusState, equals: .jobTitle)
            .onSubmit {
                focusState = .notes
            }
            .cellPadding()
        }
        .cellBackground()
    }
    
    
    private var notesView: some View {
        VStack(alignment: .leading) {
            TextField("Notes", text: $shareExtensionViewModel.notes, axis: .vertical)
                .lineLimit(5...8)
                .cellPadding()
                .cellBackground()
        }
    }
    
    private var addButton: some View {
            Button(action: {
                shareExtensionViewModel.saveJob(context: container)
                action()
            }, label: {
                Text("Add to Job Tracker App")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .cellPadding()
                
            })
            .padding(.horizontal, 16)
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
            .tint(.mint)
            .disabled(shareExtensionViewModel.isTitleOrCompanyEmpty())
    }
    
}
