//
//  TabViewRoot.swift
//  Jobs
//
//  Created by Rui Silva on 09/05/2024.
//

import SwiftUI

struct TabViewRoot: View {
    @ObservedObject private var appViewModel: MainViewViewModel
    @ObservedObject private var overViewViewModel: OverViewViewModel
    
    public init(appViewModel: MainViewViewModel, 
                overViewViewModel: OverViewViewModel) {
        self.appViewModel = appViewModel
        self.overViewViewModel = overViewViewModel
    }
    
    var body: some View {
        TabView {
            MainView(appViewModel: appViewModel)
                .tabItem {
                    Label("Home", systemImage: "list.clipboard")
                }
            
            OverView(overViewViewModel: overViewViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.3.group.fill")
                }
        }
    }
}
