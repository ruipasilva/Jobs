//
//  MainView.swift
//  Jobs
//
//  Created by Rui Silva on 22/01/2024.
//

import SwiftUI
import SwiftData

enum SortOrder: String, Identifiable, CaseIterable {
    case status, title, company
    
    var id: Self {
        self
    }
    
    var status: String {
        switch self {
        case .title:
            return "Title"
        case .company:
            return "Company"
        case .status:
            return "Status"
        }
    }
    
}

struct MainView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Job.company) private var jobs: [Job]
    @State private var isShowingNewJob = false
    @State private var sortOrder = SortOrder.company
    
    var body: some View {
        NavigationStack {
            JobListView(sortOrder: sortOrder)
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
