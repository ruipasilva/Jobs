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
    
    @ObservedObject var mainViewModel: MainViewViewModel
    
    var totalJobs: Int
    var interviewStatus: String
    var SFSymbol: String
    var circleColor: Color
    
    var body: some View {
        ZStack {
            roundedRectangle
            infoView
                .padding(16)
        }
        .frame(
            height: horizontalSizeClass == .compact
            ? UIScreen.main.bounds.width / 3
            : UIScreen.main.bounds.width / 9
        )
        .padding(.bottom)
    }
    
    private var roundedRectangle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemGroupedBackground))
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
                    .foregroundColor(Color(uiColor: .label))
            }
            Spacer()
            Text(interviewStatus)
                .font(.body)
                .bold()
                .foregroundColor(Color(uiColor: .label))
        }
    }
}
