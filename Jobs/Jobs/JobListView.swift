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
//        case .status:
//            [SortDescriptor(\Job.status, order: appViewModel.ascendingDescending)]
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
                ContentUnavailableView("No jobs yet", systemImage: "folder")
            } else {
                List {
                    ForEach(jobs) { job in
                        NavigationLink {
                            EditJobView(appViewModel: appViewModel, job: job)
                        } label: {
                            HStack {
                                LazyVStack(alignment: .leading) {
                                    Text(job.company)
                                    Text(job.title)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text(job.status)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let book = jobs[index]
                            context.delete(book)
                        }
                    }
                }
            }
        }
    }
}
