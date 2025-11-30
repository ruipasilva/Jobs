//
//  TabViewRoot.swift
//  Jobs
//
//  Created by Rui Silva on 09/05/2024.
//

import SwiftUI

struct TabViewRoot: View {
    @SceneStorage("SelectedTab") var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Jobs", systemImage: "list.clipboard", value: 0) {
                MainView()
            }

            Tab("Insights", systemImage: "chart.pie.fill", value: 1) {
                InsightsView()
            }
            if tabSelection() {
                Tab("Search", systemImage: "magnifyingglass", value: 2, role: .search) {
                    MainView()
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
    
    private func tabSelection() -> Bool {
        selectedTab == 0 || selectedTab == 2
    }
}
