//
//  JobListView.swift
//  Jobs
//
//  Created by Rui Silva on 24/01/2024.
//

import SwiftUI
import SwiftData

struct JobListView: View {
    @ObservedObject private var appViewModel: AppViewModel
    @Environment(\.modelContext) private var context
    @Query private var jobs: [Job]
    
    init(appViewModel: AppViewModel,
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
                list
            }
        }
    }
    
    private var emptyList: some View {
        ContentUnavailableView("No jobs yet", systemImage: "folder")
    }
    
    private var list: some View {
        List {
            Section {
                RectanglesView(appViewModel: appViewModel)
                    .listRowBackground(Color.clear)
            }
            .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowSeparator(.hidden)
            Section {
                ForEach(jobs) { job in
                    ZStack {
                        MainListCellView(job: job)
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
                        let book = jobs[index]
                        context.delete(book)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSpacing(6)
            }
            .listRowInsets(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
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
                appViewModel.setApplicationStatus(job: job, status: .interviewing)
            }) {
                Label {
                    Text("Interview")
                } icon: {
                    Image(systemName: "person.3.fill")
                }
            }
            
            Button(action: {
                appViewModel.setApplicationStatus(job: job, status: .accepted)
            }) {
                Label {
                    Text("Accepted")
                } icon: {
                    Image(systemName: "person.fill.checkmark")
                }
                .tint(.indigo)
            }
        }
    }
}
