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
        
        print("job: \(job.logoURL)")
        print("view model: \(logoOptionsViewModel.logoURL)")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Company Name", text: $logoOptionsViewModel.company)
                    .padding()
                    .onChange(of: logoOptionsViewModel.company) { oldValue, newValue in
                        Task {
                            await logoOptionsViewModel.getLogos(company: logoOptionsViewModel.company)
                        }
                    }
                TextField("Job Title", text: $logoOptionsViewModel.title)
                    .padding()
                
                switch logoOptionsViewModel.loadingLogoState {
                case .na:
                    ProgressView()
                case let .success(data):
                    logoList(logoData: data)
                case let .failed(error):
                    Text(error.title)
                }
                Spacer()
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
