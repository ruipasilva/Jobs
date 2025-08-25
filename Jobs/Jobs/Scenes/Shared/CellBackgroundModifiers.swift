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
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
            }
            .padding(.horizontal)
    }
}

struct CellPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 4)
    }
}

extension View {
    func cellBackground(isAnotherCellBellow: Bool? = true) -> some View {
        modifier(CellBackground())
            .padding(.bottom, isAnotherCellBellow! ? 28 : 0)
    }

    func cellPadding() -> some View {
        modifier(CellPadding())
    }
}
