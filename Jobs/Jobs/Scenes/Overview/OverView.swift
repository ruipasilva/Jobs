//
//  OverView.swift
//  Jobs
//
//  Created by Rui Silva on 06/07/2024.
//

import SwiftUI

struct OverView: View {
    @StateObject private var overViewViewModel = OverViewViewModel()

    var body: some View {
        NavigationStack {
            Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
                .navigationTitle("Overview")
                .toolbar {
                    toolbarTrailing
                }
                .sheet(isPresented: $overViewViewModel.isShowingSettings) {
                    SettingsView()
                }

        }
    }

    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(
                action: {
                    overViewViewModel.isShowingSettings.toggle()
                },
                label: {
                    Image(systemName: "gearshape.fill")
                })
        }
    }
}
