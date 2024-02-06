//
//  NewJobView.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI

struct NewJobView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var appViewModel: AppViewModel
    
    @State private var title = ""
    @State private var company = ""
    
    public init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Job Title", text: $title)
                TextField("Compnay Name", text: $company)
                
                Button("Create") {
                    let newJob = Job(title: title, company: company)
                    context.insert(newJob)
                    dismiss()
                }
                .disabled(title.isEmpty || company.isEmpty)
                Button(appViewModel.isNewJobExpanded ? "Collapse" : "Expand") {
                    appViewModel.setPresentationDetents()
                }
            }
            .onChange(of: appViewModel.selectedDetent, {
                appViewModel.setPresentationDetents()
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
