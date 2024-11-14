//
//  MainListCellView.swift
//  Jobs
//
//  Created by Rui Silva on 01/04/2024.
//

import SwiftUI

struct MainListCellView: View {
    @ObservedObject private var appViewModel: MainViewViewModel
    @Environment(\.colorScheme) var colorScheme

    var job: Job

    public init(appViewModel: MainViewViewModel,
                job: Job) {
        self.appViewModel = appViewModel
        self.job = job
    }

    var body: some View {
        ZStack {
            roundedRectangle
            infoView
                .padding(.horizontal, 16)
        }
    }

    private var roundedRectangle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(applyBackgroungColor(for: job))
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
            .frame(width: 56, height: 56)

            VStack(alignment: .leading) {
                HStack {
                    Text(job.company.isEmpty ? "Company Name" : job.company)
                        .font(.body)
                        .foregroundColor(Color.init(UIColor.label))
                        .padding(.bottom, 2)
                    Spacer()
                    Text(job.jobApplicationStatus.status)
                        .font(.subheadline)
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                }
                Text(job.title.isEmpty ? "Job Title" : job.title)
                    .font(.subheadline)
                    .foregroundColor(Color.init(UIColor.secondaryLabel))
            }
        }
        .padding(.vertical, 10)
    }

    private var defaultImage: some View {
        Image(systemName: "suitcase")
            .resizable()
            .foregroundColor(.mint)
            .frame(width: 42, height: 38)
    }

    private func applyBackgroungColor(for job: Job) -> LinearGradient {
    
        switch job.jobApplicationStatus {
        case .applied:
            return LinearGradient(
                gradient: Gradient(colors: [
                    .clear, Color.init(UIColor.secondarySystemBackground),
                    Color.init(UIColor.secondarySystemBackground),
                    .orange.opacity(0.2),
                ]), startPoint: .leading, endPoint: .trailing)
        case .started:
            return LinearGradient(
                gradient: Gradient(colors: [
                    .clear, Color.init(UIColor.secondarySystemBackground),
                    Color.init(UIColor.secondarySystemBackground),
                    .mint.opacity(0.2),
                ]), startPoint: .leading, endPoint: .trailing)
        case .rejected:
            return LinearGradient(
                gradient: Gradient(colors: [
                    .clear, Color.init(UIColor.secondarySystemBackground),
                    Color.init(UIColor.secondarySystemBackground),
                    .red.opacity(0.2),
                ]), startPoint: .leading, endPoint: .trailing)
        case .hired:
            return LinearGradient(
                gradient: Gradient(colors: [
                    .clear, Color.init(UIColor.secondarySystemBackground),
                    Color.init(UIColor.secondarySystemBackground),
                    .green.opacity(0.2),
                ]), startPoint: .leading, endPoint: .trailing)
        case .notApplied:
            return LinearGradient(
                gradient: Gradient(colors: [
                    .clear, Color.init(UIColor.secondarySystemBackground),
                    Color.init(UIColor.secondarySystemBackground),
                ]), startPoint: .leading, endPoint: .trailing)
        }
    }
}
