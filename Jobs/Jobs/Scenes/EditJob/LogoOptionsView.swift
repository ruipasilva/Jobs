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
                Section {
                    AnimatedTextField(text: $logoOptionsViewModel.company, label: {
                        Text("Company Name")
                    })
//                    FloatingTextField(title: "Company Name", text: $logoOptionsViewModel.company, image: "building.2")
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
//                    FloatingTextField(title: "Job Title", text: $logoOptionsViewModel.title, image: "person")
                } header: {
                    Text("Edit Main Info")
                }
                if !logoOptionsViewModel.company.isEmpty {
                    Section {
                        switch logoOptionsViewModel.loadingLogoState {
                        case .na:
                            ProgressView()
                        case let .success(data):
                            ForEach(data, id: \.logo) { data in
                                Button(action: {
                                    logoOptionsViewModel.logoURL = data.logo
                                    logoOptionsViewModel.company = data.name
                                }, label: {
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
                                            @unknown default:
                                                Image(systemName: "suitcase.fill")
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(data.name)
                                                .font(.body)
                                                .foregroundColor(Color.init(UIColor.label))
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
    
    public func logoList(logoData: [CompanyInfo]) -> some View {
        LazyVGrid(columns: collums) {
            ForEach(logoData, id: \.logo) { data in
                Button(action: {
                    logoOptionsViewModel.logoURL = data.logo
                }, label: {
                    VStack {
                        AsyncImage(url: URL(string: data.logo), scale: 2)
                        
                        if logoOptionsViewModel.logoURL == data.logo {
                            Text("Current")
                        } else {
                            Spacer(minLength: 50)
                        }
                    }
                })
            }
        }
        .padding()
    }
}
