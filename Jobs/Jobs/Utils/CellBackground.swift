//
//  EditJobViewBackgroundModifier.swift
//  Jobs
//
//  Created by Rui Silva on 08/09/2024.
//

import SwiftUI

struct CellBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
    }
}

struct CellPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 6)
    }
}

extension View {
    func cellBackground() -> some View {
        modifier(CellBackground())
    }
    
    func cellPadding() -> some View {
        modifier(CellPadding())
    }
}
