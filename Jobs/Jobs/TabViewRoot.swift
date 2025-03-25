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

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.pie.fill")
                }
        }
    }
}
