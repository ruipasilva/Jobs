//
//  TabViewRoot.swift
//  Jobs
//
//  Created by Rui Silva on 09/05/2024.
//

import SwiftUI

struct TabViewRoot: View {
    @ObservedObject private var appViewModel: AppViewModel
    
    public init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        TabView {
            MainView(appViewModel: appViewModel)
                .tabItem {
                    Label("Home", systemImage: "list.clipboard")
                }
            
            Text("Second Tab")
                .tabItem {
                    Label("Overview", systemImage: "gearshape")
                }
        }
    }
}
