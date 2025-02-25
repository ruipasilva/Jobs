//
//  InsightsInfoView.swift
//  Jobs
//
//  Created by Rui Silva on 19/02/2025.
//

import SwiftUI

struct InsightsInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let description: String
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text(description)
                    .font(.body)
                    .padding(.horizontal, 16)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarTrailing
            }
        }
    }
    
    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
            }

        }
    }
}

