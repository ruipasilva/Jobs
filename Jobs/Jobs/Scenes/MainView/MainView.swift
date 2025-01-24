//
//  MainView.swift
//  Jobs
//
//  Created by Rui Silva on 22/01/2024.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel = MainViewViewModel()
    @Query private var jobs: [Job]
    @AppStorage("sortingOrder") var sortingOrder: SortingOrder = .dateAdded
    
    var body: some View {
        NavigationStack {
            JobListView(mainViewModel: mainViewModel,
                        sortOrder: sortingOrder,
                        filterString: mainViewModel.filter)
            .padding(.bottom, 10)
            .background(Color(UIColor.systemBackground))
            .searchable(text: $mainViewModel.filter,
                        prompt: "Search for companies or job titles")
            .toolbar {
                toolbarTrailing
                toolBarLeading
            }
            .sheet(isPresented: $mainViewModel.isShowingNewJobView) {
                NewJobView(action: {})
            }
            .navigationTitle("Your Jobs")
        }
        .tint(.mint)
        .onAppear(perform: {
            mainViewModel.sortingOrder = sortingOrder
        })
        .onChange(of: mainViewModel.sortingOrder) { _, _ in
            sortingOrder = mainViewModel.sortingOrder
        }
    }
    
    private var toolBarLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            sortMenu
        }
    }
    
    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            addNewJobButton
        }
    }
    
    private var sortMenu: some View {
        Menu {
            Picker("Sort", selection: $mainViewModel.sortingOrder) {
                ForEach(SortingOrder.allCases) {
                    Text($0.status)
                }
            }
            
            Section("Order") {
                Button(
                    action: {
                        mainViewModel.sortAscendingOrDescending(
                            order: .forward)
                    },
                    label: {
                        Label("Ascending", systemImage: "arrow.down")
                    })
                
                Button(
                    action: {
                        mainViewModel.sortAscendingOrDescending(
                            order: .reverse)
                    },
                    label: {
                        Label("Descending", systemImage: "arrow.up")
                    })
            }
        } label: {
            Text("Sort")
        }
        .disabled(jobs.isEmpty)
    }
    
    private var addNewJobButton: some View {
        Button(
            action: {
                mainViewModel.showNewJobSheet()
            },
            label: {
                Image(systemName: "plus")
            })
    }
}
