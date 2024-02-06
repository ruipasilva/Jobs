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
    @FocusState private var focusState: Bool
    
    @State private var title = ""
    @State private var company = ""
    
    public init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Job Title", text: $title)
                    .focused($focusState)
                TextField("Compnay Name", text: $company)
                    .focused($focusState)
                
                Button("Create") {
                    let newJob = Job(title: title, company: company)
                    context.insert(newJob)
                    dismiss()
                }
                .disabled(title.isEmpty || company.isEmpty)
                Button(appViewModel.isNewJobExpanded ? "Collapse" : "Expand") {
                    appViewModel.setPresentationDetents()
                    if focusState {
                        focusState.toggle()
                    }
                }
            }
            .onChange(of: appViewModel.selectedDetent, {
                appViewModel.setPresentationDetents()
            })
            .onChange(of: focusState, { oldValue, newValue in
                if oldValue {
                    appViewModel.isNewJobExpanded = false
                } else {
                    appViewModel.isNewJobExpanded = true
                }
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
