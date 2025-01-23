//
//  JobListView.swift
//  Jobs
//
//  Created by Rui Silva on 24/01/2024.
//

import SwiftData
import SwiftUI

struct JobListView: View {
    @ObservedObject private var mainViewModel: MainViewViewModel
    @Environment(\.modelContext) private var context
    @Query private var jobs: [Job]

    init(mainViewModel: MainViewViewModel,
        sortOrder: SortingOrder,
        filterString: String) {
        self.mainViewModel = mainViewModel

        let sortDescriptors: [SortDescriptor<Job>] =
            switch sortOrder {
            case .status:
                [SortDescriptor(\Job.jobApplicationStatusPrivate, order: mainViewModel.ascendingDescending), SortDescriptor(\Job.dateAdded)]
            case .title:
                [SortDescriptor(\Job.title, order: mainViewModel.ascendingDescending)]
            case .company:
                [SortDescriptor(\Job.company, order: mainViewModel.ascendingDescending)]
            case .salary:
                [SortDescriptor(\Job.salary, order: mainViewModel.ascendingDescending)]
            case .dateAdded:
                [SortDescriptor(\Job.dateAdded, order: mainViewModel.ascendingDescending)]
            @unknown default:
                [SortDescriptor(\Job.company, order: mainViewModel.ascendingDescending)]
            }
        
        let filter = #Predicate<Job> { job in
            job.company.localizedStandardContains(filterString) || job.title.localizedStandardContains(filterString) || filterString.isEmpty
        }
        _jobs = Query(filter: filter, sort: sortDescriptors)
    }

    var body: some View {
        Group {
            if jobs.isEmpty {
                emptyList
            } else {
                jobList
            }
        }
    }

    private var emptyList: some View {
        // SwiftUI standard library view
        ContentUnavailableView("No jobs yet", systemImage: "folder")
    }

    private var jobList: some View {
        List {
            Section {
                RectanglesView(mainViewModel: mainViewModel)
            }
            .padding(.bottom, -16)
            .listRowSeparator(.hidden)
            Section {
                ForEach(jobs) { job in
                    ZStack {
                        MainListCellView(mainViewModel: mainViewModel,
                                         job: job)
                        NavigationLink {
                            EditJobView(job: job)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        makeSwipeView(job: job)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let job = jobs[index]
                        context.delete(job)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    // Possibly change this to an Enum and iterate over cases to reduce code
    private func makeSwipeView(job: Job) -> some View {
        Group {
            Button(action: {
                mainViewModel.setApplicationStatus(job: job, status: .applied)
            }) {
                Label {
                    Text("Applied")
                } icon: {
                    Image(systemName: "paperplane")
                }
                .tint(.orange)
            }
            
            Button(action: {
                mainViewModel.setApplicationStatus(job: job, status: .started)
            }) {
                Label {
                    Text("Started")
                } icon: {
                    Image(systemName: "calendar.badge.checkmark")
                }
            }

            Button(action: {
                mainViewModel.setApplicationStatus(job: job, status: .rejected)
            }) {
                Label {
                    Text("Rejected")
                } icon: {
                    Image(systemName: "xmark.circle")
                }
                .tint(.red)
            }
        }
    }
}
