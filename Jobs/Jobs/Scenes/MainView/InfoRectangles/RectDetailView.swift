//
//  RectDetailView.swift
//  Jobs
//
//  Created by Rui Silva on 24/04/2024.
//

import SwiftUI

struct RectDetailView: View {
    @ObservedObject private var appViewModel: MainViewViewModel
    @Environment(\.dismiss) private var dismiss

    let jobs: [Job]
    let title: String

    public init(appViewModel: MainViewViewModel,
                jobs: [Job],
                title: String) {
        self.appViewModel = appViewModel
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
        List(jobs, id: \.company) { job in
            MainListCellView(appViewModel: appViewModel, job: job)
                .listRowInsets(
                    .init(top: 0, leading: 16, bottom: 8, trailing: 16)
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
