//
//  MainListCellView.swift
//  Jobs
//
//  Created by Rui Silva on 01/04/2024.
//

import SwiftUI

struct MainListCellView: View {
    @ObservedObject private var appViewModel: AppViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var job: Job

    public init(appViewModel: AppViewModel, job: Job) {
        self.appViewModel = appViewModel
        self.job = job
    }
    
    var body: some View {
        ZStack {
            roundedRectangle
            infoView
                .padding(.horizontal, 16)
        }
        .frame(height: 83)
    }
    
    private var roundedRectangle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(colorScheme == .dark ? Color.init(UIColor.secondarySystemBackground) : Color.init(UIColor.systemGroupedBackground))
    }
    
    private var infoView: some View {
        HStack {
                AsyncImage(url: URL(string: job.logoURL)) { phase in
                    switch phase {
                    case .empty:
                        if job.logoURL.isEmpty {
                            defaultImage
                        } else {
                            ProgressView()
                        }
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                    case .failure(_):
                        defaultImage
                    @unknown default:
                        defaultImage
                    }
                }
            .frame(width: 55, height: 55)
            VStack(alignment: .leading) {
                HStack {
                    Text(job.company)
                        .font(.body)
                        .foregroundColor(Color.init(UIColor.label))
                        .padding(.bottom, 2)
                    Spacer()
                    Text(job.jobApplicationStatus.status)
                        .font(.subheadline)
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                }
                Text(job.title)
                    .font(.subheadline)
                    .foregroundColor(Color.init(UIColor.secondaryLabel))
            }
        }
    }
    
    private var defaultImage: some View {
        Image(systemName: "suitcase.fill")
            .resizable()
            .foregroundColor(.mint)
            .frame(width: 36, height: 36)
    }
}

