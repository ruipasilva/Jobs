//
//  EditJobView.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI

struct EditJobView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    let job: Job
    
    @State private var title = ""
    @State private var company = ""
    @State private var jobApplicationStatus = JobApplicationStatus.notApplied
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Job Title", text: $title)
                TextField("Company Name", text: $company)
                HStack {
                    Text("Status")
                    Picker("Status", selection: $jobApplicationStatus) {
                        ForEach(JobApplicationStatus.allCases) { status in
                            Text(status.status).tag(status)
                        }
                    }
                }
            }
            .padding()
            .toolbar {
                Button("Update") {
                    job.title = title
                    job.company = company
                    job.jobApplicationStatus = jobApplicationStatus
                    dismiss()
                }
            }
        }
        .onAppear {
            title = job.title
            company = job.company
            jobApplicationStatus = job.jobApplicationStatus
        }
    }
}

//#Preview {
//    EditJobView()
//}
