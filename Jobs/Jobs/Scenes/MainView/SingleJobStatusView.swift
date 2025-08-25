//
//  RectDetailView.swift
//  Jobs
//
//  Created by Rui Silva on 24/04/2024.
//

import SwiftUI

struct SingleJobStatusView: View {
    @ObservedObject private var mainViewModel: MainViewViewModel
    @Environment(\.dismiss) private var dismiss

    let jobs: [Job]
    let title: String

    public init(mainViewModel: MainViewViewModel,
                jobs: [Job],
                title: String) {
        self.mainViewModel = mainViewModel
        self.jobs = jobs
        self.title = title
    }

    var body: some View {
        NavigationStack {
            Group {
                if jobs.isEmpty {
                    emptyListView
                } else {
                    listView
                }
            }
            .padding(.vertical)
            .listStyle(.plain)
            .navigationTitle(jobs.isEmpty ? "" : title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarTrailing
            }
        }
    }

    private var listView: some View {
        List(jobs, id: \.id) { job in
            MainListCellView(mainViewModel: mainViewModel, job: job)
                .listRowInsets(
                    .init(top: 6, leading: 16, bottom: 6, trailing: 16)
                )
                .listRowSeparator(.hidden)
        }
    }

    private var emptyListView: some View {
        ContentUnavailableView(
            "No \(title) jobs", systemImage: "folder.badge.questionmark")
    }

    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(
                action: {
                    dismiss()
                },
                label: {
                    Text("Dismiss")
                })
        }
    }
}
