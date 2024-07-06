//
//  TabViewRoot.swift
//  Jobs
//
//  Created by Rui Silva on 09/05/2024.
//

import SwiftUI

struct TabViewRoot: View {
    @ObservedObject private var appViewModel: MainViewViewModel
    @ObservedObject private var overViewViewModel: OverviewViewModel
    
    public init(appViewModel: MainViewViewModel, 
                overViewViewModel: OverviewViewModel) {
        self.appViewModel = appViewModel
        self.overViewViewModel = overViewViewModel
    }
    
    var body: some View {
        TabView {
            MainView(appViewModel: appViewModel)
                .tabItem {
                    Label("Home", systemImage: "list.clipboard")
                }
            
            Overview(overViewViewModel: overViewViewModel)
                .tabItem {
                    Label("Overview", systemImage: "gearshape")
                }
        }
    }
}
