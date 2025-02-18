//
//  TabViewRoot.swift
//  Jobs
//
//  Created by Rui Silva on 09/05/2024.
//

import SwiftUI

struct TabViewRoot: View {

    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Jobs", systemImage: "list.clipboard")
                }
            
//            OnlineJobsView()
//                .tabItem {
//                    Label("Online", systemImage: "globe")
//                }

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.pie.fill")
                }
        }
    }
}
