//
//  LogoOptionsView.swift
//  Jobs
//
//  Created by Rui Silva on 03/04/2024.
//

import SwiftUI

struct LogoOptionsView: View {
    @StateObject private var logoOptionsViewModel: LogoOptionsViewModel
    @Environment(\.dismiss) private var dismiss
    
    public init(job: Job) {
        self._logoOptionsViewModel = .init(wrappedValue: .init(job: job))
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
                        dismiss()
                    }
                    .disabled(logoOptionsViewModel.isTitleOrCompanyEmpty())
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await logoOptionsViewModel.getLogos(
                company: logoOptionsViewModel.job.company)
        }
    }
    
    private var mainInfoView: some View {
        Section {
            AnimatedTextField(text: $logoOptionsViewModel.job.company, label: {
                Text("Company Name")
            })
            .onChange(of: logoOptionsViewModel.job.company) { _, _ in
                Task {
                    await logoOptionsViewModel.getLogos(
                        company: logoOptionsViewModel.job.company)
                }
            }
            .submitLabel(.continue)
            
            AnimatedTextField(text: $logoOptionsViewModel.job.title, label: {
                Text("Job Title")
            })
            
            AnimatedTextField(text: $logoOptionsViewModel.job.companyWebsite, label: {
                Text("Company Website")
            })
        } header: {
            Text("Main Info")
        }
    }
    
    private var pickLogoView: some View {
        Group {
            if !logoOptionsViewModel.job.company.isEmpty {
                Section {
                    switch logoOptionsViewModel.loadingLogoState {
                    case .na:
                        ProgressView()
                    case let .success(result):
                        ForEach(result, id: \.logo) { data in
                            Button(action: {
                                logoOptionsViewModel.job.logoURL = data.logo
                                logoOptionsViewModel.job.companyWebsite =
                                data.domain
                            }, label: {
                                HStack {
                                    AsyncImage(url: URL(string: data.logo),
                                               scale: 3) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(alignment: .center)
                                        case .success(let image):
                                            image
                                                .cornerRadius(8)
                                                .shadow(radius: 2)
                                        case .failure(_):
                                            Image(
                                                systemName: "suitcase.fill"
                                            )
                                            .controlSize(.large)
                                        @unknown default:
                                            Image(
                                                systemName: "suitcase.fill")
                                        }
                                    }
                                    
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
                                    if logoOptionsViewModel.job.logoURL == data.logo {
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
