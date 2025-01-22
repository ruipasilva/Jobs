//
//  SettingsView.swift
//  Jobs
//
//  Created by Rui Silva on 04/11/2024.
//

import SwiftUI
import ShareJobFramework

struct SettingsView: View {
    @AppStorage("CurrencyType") var currencyType: CurrencyType = .dolar
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Your preferred currency:", selection: $currencyType)
                    {
                        ForEach(CurrencyType.allCases) { currencyType in
                            Text(currencyType.rawValue)
                        }
                    }
                } header: {
                    Text("Currency")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                toolbarTrailing
            }
        }
    }

    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}

#Preview {
    SettingsView()
}
