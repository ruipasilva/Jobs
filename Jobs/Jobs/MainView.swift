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
    @State private var sortOrder = SortOrder.company
    
    @State private var filter = ""
    
    var body: some View {
        NavigationStack {
            JobListView(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: "Search for companies or job titles")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isShowingNewJob = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort", selection: $sortOrder) {
                            ForEach(SortOrder.allCases) {
                                Text($0.status)
                            }
                        }
                    } label: {
                        Text("Sort")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewJob) {
                NewJobView()
            }
        }
    }
}
