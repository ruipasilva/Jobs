//
//  MainView.swift
//  Jobs
//
//  Created by Rui Silva on 22/01/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @ObservedObject private var appViewModel: AppViewModel
    @Query(sort: \Job.company) private var jobs: [Job]
    @AppStorage("sortOrdering") var sortOrdering: SortOrdering = .title
    
    public init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        NavigationStack {
            JobListView(appViewModel: appViewModel,
                        sortOrder: appViewModel.sortOrdering,
                        filterString: appViewModel.filter)
            .searchable(text: $appViewModel.filter, prompt: "Search for companies or job titles")
            .toolbar {
                toolbarTrailing
                toolBarLeading
            }
            .sheet(isPresented: $appViewModel.isShowingNewJob) {
                NewJobView(appViewModel: appViewModel)
            }
        }
        .tint(.mint)
        .onAppear(perform: {
            appViewModel.sortOrdering = sortOrdering
        })
    }
    
    private var toolBarLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                ForEach(SortOrdering.allCases, id: \.id) { sort in
                    Button(action: {
                        appViewModel.sortOrdering = sort
                        sortOrdering = sort
                    }, label: {
                        Label(sort.status, systemImage: "")
                    })
                }
                
                Section("Order") {
                    Button(action: {
                        appViewModel.ascendingDescending = .forward
                    }, label: {
                        Label("Ascending", systemImage: "arrow.down")
                    })
                    
                    Button(action: {
                        appViewModel.ascendingDescending = .reverse
                    }, label: {
                        Label("Descending", systemImage: "arrow.up")
                    })
                }
            } label: {
                Text("Sort")
            }
        }
    }
    
    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                appViewModel.isShowingNewJob = true
            }, label: {
                Image(systemName: "plus")
            })
        }
    }
}
