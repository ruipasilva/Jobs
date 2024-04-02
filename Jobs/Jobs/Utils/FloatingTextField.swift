//
//  FloatingTextField.swift
//  Jobs
//
//  Created by Rui Silva on 26/03/2024.
//

import SwiftUI

struct FloatingTextField: View {
    let title: String
    @Binding public var text: String
    let image: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(Color(.placeholderText))
                    .offset(y: $text.wrappedValue.isEmpty ? 0 : -25)
                    .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.8, anchor: .leading)
                TextField("", text: $text)
            }
        }
        .padding(.top, text.isEmpty ? 10 : 15)
        .padding(.bottom, 5)
        .animation(.spring(response: 0.2, dampingFraction: 0.5))
    }
}
