//
//  JobListView.swift
//  Jobs
//
//  Created by Rui Silva on 24/01/2024.
//

import SwiftUI
import SwiftData

struct JobListView: View {
    @Environment(\.modelContext) private var context
    @Query private var jobs: [Job]
    
    init(sortOrder: SortOrder) {
        let sortDescriptors: [SortDescriptor<Job>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Job.company), SortDescriptor(\Job.title)]
        case .title:
            [SortDescriptor(\Job.title)]
        case .company:
            [SortDescriptor(\Job.company)]
        }
        _jobs = Query(sort: sortDescriptors)
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
