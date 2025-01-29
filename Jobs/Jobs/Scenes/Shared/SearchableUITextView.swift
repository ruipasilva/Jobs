//
//  SearchableKeyboard.swift
//  Jobs
//
//  Created by Rui Silva on 28/01/2025.
//

import Foundation
import SwiftUI

struct SearchableUITextView: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    
    var action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    
    init(_ placeholder: String, text: Binding<String>, action: @escaping () -> Void) {
        self.placeholder = placeholder
        _text = text
        self.action = action
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textview = UITextView()
        textview.delegate = context.coordinator
        textview.isScrollEnabled = true
        textview.adjustsFontForContentSizeCategory = true
        textview.textContainerInset = .zero
        textview.contentInset = .zero
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        placeholderLabel.textColor = UIColor.gray
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textview.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: textview.leadingAnchor, constant: 5),
            placeholderLabel.topAnchor.constraint(equalTo: textview.topAnchor, constant: 4),
            placeholderLabel.trailingAnchor.constraint(equalTo: textview.trailingAnchor, constant: -5)
        ])
        
        placeholderLabel.isHidden = !textview.text.isEmpty
        
        return textview
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        if colorScheme == .dark {
            uiView.backgroundColor = .secondarySystemBackground
        } else {
            uiView.backgroundColor = .systemBackground
        }
        uiView.font = UIFont.preferredFont(forTextStyle: .body)
        uiView.text = text
        
        uiView.subviews.first { $0 is UILabel }?.isHidden = !text.isEmpty
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: SearchableUITextView
        
        init(_ parent: SearchableUITextView) {
            self.parent = parent
        }
        
        func textViewDidChangeSelection(_ textField: UITextView) {
            parent.text = textField.text ?? ""
        }
        
        func textViewDidEndEditing(_ textField: UITextView) {
            parent.action()
        }
    }
}

extension UIBarButtonItem {
    static func flexibleSpace() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}
