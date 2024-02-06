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
         sortOrder: SortOrder,
         filterString: String) {
        self.appViewModel = appViewModel
        let sortDescriptors: [SortDescriptor<Job>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Job.company), SortDescriptor(\Job.title)]
        case .title:
            [SortDescriptor(\Job.title)]
        case .company:
            [SortDescriptor(\Job.company)]
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
                            EditJobView(job: job)
                        } label: {
                            HStack {
                                LazyVStack(alignment: .leading) {
                                    Text(job.company)
                                    Text(job.title)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text("Status")
                                job.icon
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
