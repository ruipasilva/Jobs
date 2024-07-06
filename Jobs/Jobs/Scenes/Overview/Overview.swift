//
//  Overview.swift
//  Jobs
//
//  Created by Rui Silva on 06/07/2024.
//

import SwiftUI

struct Overview: View {
    @ObservedObject private var overViewViewModel: OverviewViewModel
    
    public init(overViewViewModel: OverviewViewModel) {
        self.overViewViewModel = overViewViewModel
    }
    
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle("Overview")
        }
    }
}
