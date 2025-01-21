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
                    Label("Home", systemImage: "list.clipboard")
                }
            
//            OnlineJobsView()
//                .tabItem {
//                    Label("Online", systemImage: "globe")
//                }

            OverView()
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.3.group.fill")
                }
        }
    }
}
