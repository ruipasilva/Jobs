//
//  LogoOptionsView.swift
//  Jobs
//
//  Created by Rui Silva on 03/04/2024.
//

import SwiftUI

struct LogoOptionsView: View {
    @ObservedObject private var logoOptionsViewModel: LogoOptionsViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusState: FocusedField?
    @Environment(\.modelContext) private var context
    
    public init(logoOptionsViewModel: LogoOptionsViewModel) {
        self.logoOptionsViewModel = logoOptionsViewModel
        
        logoOptionsViewModel.setProperties()
        
        Task {
            await logoOptionsViewModel.getLogos(
                company: logoOptionsViewModel.company)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                mainInfoView
                pickLogoView
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Update") {
                        logoOptionsViewModel.updateJob()
                        do {
                            try context.save()
                        } catch {
                            print("Error saving context: \(error)")
                        }
                        dismiss()
                    }
                    .disabled(logoOptionsViewModel.isTitleOrCompanyEmpty())
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        if logoOptionsViewModel.shouldCancelWithoutDialogAlert()  {
                            dismiss()
                        } else {
                            logoOptionsViewModel.showDiscardDialog()
                        }
                    }
                }
            }
            .confirmationDialog("Are you sure you want to discard this edit?",
                                isPresented: $logoOptionsViewModel.showingCancelActionSheet,
                                titleVisibility: .visible) {
                Button(role: .destructive, action: {
                    dismiss()
                }) {
                    Text("Discard Edit")
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var mainInfoView: some View {
        Section {
            TextfieldWithSFSymbol(text: $logoOptionsViewModel.company, placeholder: "Company Name (required)", systemName: "building.2")
                .onChange(of: logoOptionsViewModel.company) { _, _ in
                    Task {
                        await logoOptionsViewModel.getLogos(
                            company: logoOptionsViewModel.company)
                    }
                }
                .submitLabel(.next)
                .focused($focusState, equals: .companyName)
                .onSubmit {
                    focusState = .jobTitle
                }
            TextfieldWithSFSymbol(text: $logoOptionsViewModel.title, placeholder: "Job Title (required)", systemName: "person")
                .submitLabel(.next)
                .focused($focusState, equals: .jobTitle)
                .onSubmit {
                    focusState = .companyWebsite
                }
            TextfieldWithSFSymbol(text: $logoOptionsViewModel.companyWebsite, placeholder: "Company Website", systemName: "globe")
                .submitLabel(.return)
                .focused($focusState, equals: .companyWebsite)
        }
    }
    
    private var pickLogoView: some View {
        Group {
            if !logoOptionsViewModel.company.isEmpty {
                Section {
                    switch logoOptionsViewModel.loadingLogoState {
                    case .na:
                        ProgressView()
                    case let .success(result):
                        ForEach(result, id: \.logo) { data in
                            Button(action: {
                                logoOptionsViewModel.logoURL = data.logo
                                logoOptionsViewModel.companyWebsite = data.domain
                            }, label: {
                                HStack {
                                    CachedImage(url: data.logo, defaultLogoSize: 44)
                                        .frame(width: 44, height: 44)
                                    VStack(alignment: .leading) {
                                        Text(data.name)
                                            .font(.body)
                                            .foregroundColor(
                                                Color.init(UIColor.label)
                                            )
                                            .truncationMode(.tail)
                                            .lineLimit(1)
                                        Text(data.domain)
                                            .font(.subheadline)
                                            .foregroundColor(
                                                Color.init(
                                                    UIColor.secondaryLabel))
                                    }
                                    .foregroundStyle(
                                        Color(uiColor: .darkText)
                                    )
                                    .padding(.leading, 6)
                                    Spacer()
                                    if logoOptionsViewModel.logoURL == data.logo {
                                        Text("Current")
                                            .padding(4)
                                            .foregroundColor(
                                                Color.init(
                                                    UIColor.secondaryLabel)
                                            )
                                            .cornerRadius(6)
                                    }
                                }
                            })
                        }
                    case .failed(_):
                        Text("No Logos available")
                    }
                } header: {
                    Text("Please pick a logo")
                } footer: {
                    VStack(alignment: .leading) {
                        Text("Some logos might not be available.")
                        Text("Logos Provided by clearbit")
                    }
                }
            }
        }
    }
}
