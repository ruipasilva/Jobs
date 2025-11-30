//
//  IsSearchable.swift
//  Jobs
//
//  Created by Rui Silva on 30/11/2025.
//

import Foundation
import SwiftUI

struct IsSearchable: ViewModifier {
    let selectedTab: Int
    @Binding var filter: String
    
    func body(content: Content) -> some View {
        if selectedTab == 2 {
            content
                .searchable(text: $filter)
        } else {
            content
        }
    }
}

extension View {
    func isSearchable(selectedTab: Int, filter: Binding<String>) -> some View {
        modifier(IsSearchable(selectedTab: selectedTab, filter: filter))
    }
}
