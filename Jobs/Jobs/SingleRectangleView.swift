//
//  SingleRectangleView.swift
//  Jobs
//
//  Created by Rui Silva on 01/04/2024.
//

import SwiftUI

struct SingleRectangleView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var appViewModel: AppViewModel
    
    var totalJobs: Int
    var interviewStatus: String
    var SFSymbol: String
    var circleColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            ZStack {
                roundedRectangle
                infoView
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
            }
            .frame(height: horizontalSizeClass == .compact ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width/9)
            .padding(.bottom, 36)
        })
    }
    
    private var roundedRectangle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(colorScheme == .dark ? Color.init(UIColor.secondarySystemBackground) : Color.init(UIColor.systemGroupedBackground))
    }
    
    private var infoView: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Circle()
                        .fill(circleColor)
                        .frame(width: 38, height: 38)
                    Image(systemName: SFSymbol)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                }
                Spacer()
                Text("\(totalJobs)")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(UIColor.label))
            }
            
            Spacer()
            Text(interviewStatus)
                .font(.body)
                .bold()
                .foregroundColor(Color(UIColor.label))
        }
    }
}
