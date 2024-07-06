//
//  OverView.swift
//  Jobs
//
//  Created by Rui Silva on 06/07/2024.
//

import SwiftUI

struct OverView: View {
    @ObservedObject private var overViewViewModel: OverViewViewModel
    
    public init(overViewViewModel: OverViewViewModel) {
        self.overViewViewModel = overViewViewModel
    }
    
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle("Overview")
        }
    }
}
