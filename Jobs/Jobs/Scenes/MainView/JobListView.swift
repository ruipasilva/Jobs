//
//  JobListView.swift
//  Jobs
//
//  Created by Rui Silva on 24/01/2024.
//

import SwiftUI
import SwiftData

struct JobListView: View {
    @ObservedObject private var appViewModel: MainViewViewModel
    @Environment(\.modelContext) private var context
    @Query private var jobs: [Job]
    
    init(appViewModel: MainViewViewModel,
         sortOrder: SortOrdering,
         filterString: String) {
        self.appViewModel = appViewModel
        
        let sortDescriptors: [SortDescriptor<Job>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Job.jobApplicationStatusPrivate, order: appViewModel.ascendingDescending), SortDescriptor(\Job.title)]
        case .title:
            [SortDescriptor(\Job.title, order: appViewModel.ascendingDescending)]
        case .company:
            [SortDescriptor(\Job.company, order: appViewModel.ascendingDescending)]
        case .salary:
            [SortDescriptor(\Job.salary, order: appViewModel.ascendingDescending)]
        case .dateAdded:
            [SortDescriptor(\Job.dateAdded, order: appViewModel.ascendingDescending)]
        }
        let predicate = #Predicate<Job> { job in
            job.company.localizedStandardContains(filterString) ||
            job.title.localizedStandardContains(filterString) ||
            filterString.isEmpty
        }
        _jobs = Query(filter: predicate, sort: sortDescriptors)
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
        ContentUnavailableView("No jobs yet", systemImage: "folder")
    }
    
    private var jobList: some View {
        List {
            Section {
                RectanglesView(appViewModel: appViewModel)
            }
            .padding(.bottom, -16)
            .listRowSeparator(.hidden)
            
            Section {
                ForEach(jobs) { job in
                    ZStack {
                        MainListCellView(appViewModel: appViewModel,
                                         job: job)
                        NavigationLink {
                            EditJobView(job: job)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false ) {
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
    
    private func makeSwipeView(job: Job) -> some View {
        Group {
            Button(action: {
                appViewModel.setApplicationStatus(job: job, status: .applied)
            }) {
                Label {
                    Text("Applied")
                } icon: {
                    Image(systemName: "person.badge.clock.fill")
                }
                .tint(.orange)
            }
            Button(action: {
                appViewModel.setApplicationStatus(job: job, status: .started)
            }) {
                Label {
                    Text("Started")
                } icon: {
                    Image(systemName: "person.3.fill")
                }
            }
            
            Button(action: {
                appViewModel.setApplicationStatus(job: job, status: .rejected)
            }) {
                Label {
                    Text("Rejected")
                } icon: {
                    Image(systemName: "person.fill.xmark")
                }
                .tint(.red)
            }
        }
    }
}
