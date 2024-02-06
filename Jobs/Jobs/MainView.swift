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
    
    public init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        NavigationStack {
            JobListView(appViewModel: appViewModel,
                        sortOrder: appViewModel.sortOrder,
                        filterString: appViewModel.filter)
            .searchable(text: $appViewModel.filter, prompt: "Search for companies or job titles")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        appViewModel.isShowingNewJob = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort", selection: $appViewModel.sortOrder) {
                            ForEach(SortOrder.allCases) {
                                Text($0.status)
                            }
                        }
                    } label: {
                        Text("Sort")
                    }
                }
            }
            .sheet(isPresented: $appViewModel.isShowingNewJob) {
                NewJobView(appViewModel: appViewModel)
                    .presentationDetents(appViewModel.availableDetents, selection: $appViewModel.selectedDetent)
                    .onDisappear(perform: {
                        appViewModel.onDismissNewJobSheet()
                    })
            }
        }
    }
}
