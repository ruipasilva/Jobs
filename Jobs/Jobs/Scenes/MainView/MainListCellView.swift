//
//  MainListCellView.swift
//  Jobs
//
//  Created by Rui Silva on 01/04/2024.
//

import SwiftUI

struct MainListCellView: View {
    @ObservedObject private var mainViewModel: MainViewViewModel
    @Environment(\.modelContext) private var context
    
    private var job: Job
    
    public init(mainViewModel: MainViewViewModel,
                job: Job) {
        self.mainViewModel = mainViewModel
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
            .fill(Color(uiColor: .secondarySystemBackground))
            .contextMenu {
                menuItems
            }
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
            
            HStack {
                VStack(alignment: .leading) {
                    Text(job.company.isEmpty ? "Company Name" : job.company)
                        .font(.body)
                        .foregroundColor(Color.init(UIColor.label))
                        .padding(.bottom, 2)
                    
                    Text(job.title.isEmpty ? "Job Title" : job.title)
                        .font(.subheadline)
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                }
                
                Spacer()
                
                if job.jobApplicationStatus == .notApplied {
                    Image(systemName: "bookmark")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(setApplicationStatusColor(applicationStatus: job.jobApplicationStatus))
                        .background {
                            Circle()
                                .fill(setApplicationStatusColor(applicationStatus: job.jobApplicationStatus).opacity(0.2))
                        }
                } else {
                    Text(job.jobApplicationStatus.status)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(setApplicationStatusColor(applicationStatus: job.jobApplicationStatus))
                        .background {
                            RoundedRectangle(cornerRadius: 13)
                                .fill(setApplicationStatusColor(applicationStatus: job.jobApplicationStatus).opacity(0.2))
                        }
                }
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
    
    private func setApplicationStatusColor(applicationStatus: JobApplicationStatus) -> Color {
        switch applicationStatus {
        case .notApplied:
            Color(uiColor: .systemGray)
        case .applied:
            Color(uiColor: .systemOrange)
        case .started:
            Color(uiColor: .systemIndigo)
        case .rejected, .declined:
            Color(uiColor: .systemRed)
        case .offer:
            Color(uiColor: .systemGreen)
        }
    }
    
    private var menuItems: some View {
        Group {
            ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                
                Button(action: {
                    job.jobApplicationStatus = status
                }, label: {
                    HStack {
                        Text(status.status)
                        Spacer()
                        Image(systemName: status.icon)
                    }
                })
            }
            Section {
                Button(role: .destructive) {
                    mainViewModel.objectWillChange.send()
                    context.delete(job)
                } label: {
                    HStack {
                        Text("Delete")
                        Spacer()
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}
