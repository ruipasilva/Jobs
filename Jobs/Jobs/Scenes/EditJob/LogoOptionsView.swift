//
//  LogoOptionsView.swift
//  Jobs
//
//  Created by Rui Silva on 03/04/2024.
//

import SwiftUI

struct LogoOptionsView: View {
    @ObservedObject private var editJobViewModel: EditJobViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let job: Job
    
    @State private var tempCompany: String = ""
    @State private var tempTitle: String = ""
    @State private var tempLogoURL: String = ""
    
    public init(editJobViewModel: EditJobViewModel,
                job: Job) {
        self.editJobViewModel = editJobViewModel
        self.job = job
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Company Name", text: $editJobViewModel.company)
                    .padding()
                    .onChange(of: editJobViewModel.company) { oldValue, newValue in
                        Task {
                            await editJobViewModel.getLogos(company: editJobViewModel.company)
                        }
                    }
                TextField("Job Title", text: $editJobViewModel.title)
                    .padding()
                
                switch editJobViewModel.loadingLogoState {
                case .na:
                    ProgressView()
                case let .success(data):
                    logoList(logoData: data)
                case let .failed(error):
                    Text(error.title)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Update") {
                        editJobViewModel.updateInfoWithLogo(job: job)
                        dismiss()
                    }
                    .disabled(editJobViewModel.isTitleOrCompanyEmpty())
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        editJobViewModel.cancelInfoWithLogo(tempCompany: tempCompany, tempTitle: tempTitle)
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            editJobViewModel.onEditInfoAppear(job: job,
                                              logo: &tempLogoURL,
                                              company: &tempCompany,
                                              title: &tempTitle)
        }
    }
    
    public func logoList(logoData: [CompanyInfo]) -> some View {
        List(logoData, id: \.logo) { data in
            Button(action: {
                editJobViewModel.logoURL = data.logo
            }, label: {
                HStack {
                    AsyncImage(url: URL(string: data.logo), scale: 2)
                    Spacer()
                    if editJobViewModel.logoURL == data.logo {
                        Text("Selected")
                    }
                }
            })
            .buttonStyle(PlainButtonStyle())
        }
        .listStyle(.insetGrouped)
    }
}
