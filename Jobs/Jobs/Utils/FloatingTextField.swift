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

public struct AnimatedTextField<Label: View>: View {
    
    @Binding var text: String
    @FocusState var focusOnTextField
    public var label: Label
    
    @Namespace private var titleAnimation
    @State var shouldMinimiseLabel = false
    
    public init(text: Binding<String>, @ViewBuilder label: () -> Label) {
        self._text = text
        self.label = label()
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if shouldMinimiseLabel {
                    label
                        .foregroundStyle(Color(.placeholderText))
                        .scaleEffect(0.9, anchor: .topLeading)
                        .matchedGeometryEffect(id: "label", in: titleAnimation)
                }
                TextField(text: $text) {
                    EmptyView()
                }
                .focused($focusOnTextField)
            }
            
            if !shouldMinimiseLabel {
                label
                    .foregroundStyle(Color(.placeholderText))
                    .matchedGeometryEffect(id: "label", in: titleAnimation)
                    .onTapGesture {
                        focusOnTextField = true
                    }
            }
        }
        .geometryGroup()
        .onChange(of: text) { _, newValue in
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                shouldMinimiseLabel = !newValue.isEmpty
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                shouldMinimiseLabel = !text.isEmpty
            }
        }
    }
}

#Preview {
    AnimatedTextField(text: .constant("Test")) {
        Text("Name")
    }
}

