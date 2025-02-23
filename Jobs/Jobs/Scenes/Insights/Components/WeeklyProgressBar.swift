//
//  WeeklyProgressBar.swift
//  Jobs
//
//  Created by Rui Silva on 22/02/2025.
//

import SwiftUI

struct WeeklyProgressBar: View {
    var progress: Double
    var barColor: Color
    var height: CGFloat = 26
    var backgroundColor: Color = Color(UIColor.systemGray6)
    var cornerRadius: CGFloat = 6
    var text: String
    
    @State private var textWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                                    .fill(backgroundColor)
                                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(barColor)
                    .frame(width: geometry.size.width * CGFloat(progress), height: height)
                    .animation(.easeInOut(duration: 0.2), value: progress)
                
                Text(text)
                    .padding(.leading, 8)
                    .foregroundStyle(.black)
            }
        }
        .frame(height: height)
    }
}
