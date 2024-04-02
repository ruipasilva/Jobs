//
//  RectanglesView.swift
//  Jobs
//
//  Created by Rui Silva on 01/04/2024.
//

import SwiftUI

struct RectanglesView: View {
    @ObservedObject var appViewModel: AppViewModel
    
//    @FetchRequest(
//        sortDescriptors: [SortDescriptor(\.companyName)],
//        predicate: NSPredicate(format: "interviewStatus == %@", "Applied")
//    ) var jobsApllied: FetchedResults<Job>
//    
//    @FetchRequest(
//        sortDescriptors: [SortDescriptor(\.companyName)],
//        predicate: NSPredicate(format: "interviewStatus == %@", "Interviewing")
//    ) var jobsInterviewing: FetchedResults<Job>
//    
    var columns: [GridItem] {
      Array(repeating: .init(.flexible()), count: 2)
    }
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            SingleRectangleView(appViewModel: appViewModel, totalJobs: 3, interviewStatus: JobApplicationStatus.applied.status, SFSymbol: "clock", circleColor: .orange) {}
            SingleRectangleView(appViewModel: appViewModel, totalJobs: 2, interviewStatus: JobApplicationStatus.interviewing.status, SFSymbol: "checkmark", circleColor: .mint) {}
        }
    }
}
