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
    
    private let job: Job
    
    let collums: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    public init(logoOptionsViewModel: LogoOptionsViewModel,
                job: Job) {
        self.logoOptionsViewModel = logoOptionsViewModel
        self.job = job
        
        logoOptionsViewModel.setProperties(job: job)
        
        Task {
            await logoOptionsViewModel.getLogos(company: logoOptionsViewModel.company)
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
                        logoOptionsViewModel.updateJob(job: job)
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
    }
    
    private var mainInfoView: some View {
        Section {
            AnimatedTextField(text: $logoOptionsViewModel.company, label: {
                Text("Company Name")
            })
            .onChange(of: logoOptionsViewModel.company) { _, _ in
                Task {
                    await logoOptionsViewModel.getLogos(company: logoOptionsViewModel.company)
                }
                logoOptionsViewModel.updateJob(job: job)
            }
            .submitLabel(.continue)
            
            AnimatedTextField(text: $logoOptionsViewModel.title, label: {
                Text("Job Title")
            })
        
            AnimatedTextField(text: $logoOptionsViewModel.companyWebsite, label: {
                Text("Company Website")
            })
        } header: {
            Text("Main Info")
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
                                if result.isEmpty {
                                    Text("No logos available")
                                } else {
                                    HStack {
                                        AsyncImage(url: URL(string: data.logo), scale: 3) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case .success(let image):
                                                image
                                                    .cornerRadius(8)
                                                    .shadow(radius: 2)
                                            case .failure(_):
                                                Image(systemName: "suitcase.fill")
                                                    .controlSize(.large)
                                            @unknown default:
                                                Image(systemName: "suitcase.fill")
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(data.name)
                                                .font(.body)
                                                .foregroundColor(Color.init(UIColor.label))
                                                .truncationMode(.tail)
                                                .lineLimit(1)
                                            Text(data.domain)
                                                .font(.subheadline)
                                                .foregroundColor(Color.init(UIColor.secondaryLabel))
                                        }
                                        .foregroundStyle(Color(uiColor: .darkText))
                                        .padding(.leading, 6)
                                        Spacer()
                                        if logoOptionsViewModel.logoURL == data.logo {
                                            Text("Current")
                                                .padding(4)
                                                .foregroundColor(Color.init(UIColor.secondaryLabel))
                                                .cornerRadius(6)
                                        }
                                    }
                                }
                            })
                        }
                    case let .failed(error):
                        Text(error.title)
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
