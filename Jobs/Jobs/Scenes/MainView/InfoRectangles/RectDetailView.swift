//
//  RectDetailView.swift
//  Jobs
//
//  Created by Rui Silva on 24/04/2024.
//

import SwiftUI

struct RectDetailView: View {
    
    @ObservedObject private var appViewModel: AppViewModel
    
    let jobs: [Job]
    let title: String
    
    public init(appViewModel: AppViewModel,
                jobs: [Job],
                title: String) {
        self.appViewModel = appViewModel
        self.jobs = jobs
        self.title = title
    }
    
    var body: some View {
        NavigationView {
            List(jobs, id: \.company) { job in
                MainListCellView(appViewModel: appViewModel, job: job)
                    .listRowSeparator(.hidden)
            }
            .padding(.vertical)
            .listStyle(.plain)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
