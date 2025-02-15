//
//  FloatingTextField.swift
//  Jobs
//
//  Created by Rui Silva on 26/03/2024.
//

import SwiftUI

struct TextfieldWithSFSymbol: View {
    @Binding var text: String
    let placeholder: String
    let systemName: String
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .frame(width: 25, alignment: .leading)
            TextField(placeholder, text: $text)
        }
    }
}
