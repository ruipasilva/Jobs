//
//  OnlineJobsView.swift
//  Jobs
//
//  Created by Rui Silva on 20/01/2025.
//

import SwiftUI

struct OnlineJobsView: View {
    
    @StateObject var viewModel = OnlineJobsViewModel()
    
    var body: some View {
        Group {
            if viewModel.errorMessage.isEmpty {
                List(viewModel.onlineJobs, id: \.title) { job in
                    Text(job.title)
                }
            } else {
                Text(viewModel.errorMessage)
            }
        }
            .task {
                    await viewModel.fetchJobs(query: "ios")
                
            }
    }
}
