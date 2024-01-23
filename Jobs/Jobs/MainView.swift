//
//  MainView.swift
//  Jobs
//
//  Created by Rui Silva on 22/01/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Job.company) private var jobs: [Job]
    @State private var isShowingNewJob = false
    
    var body: some View {
        NavigationStack {
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
                                    Text(job.company)
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
            .toolbar {
                Button(action: {
                    isShowingNewJob = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
            .sheet(isPresented: $isShowingNewJob) {
                NewJobView()
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Job.self, inMemory: true)
}
