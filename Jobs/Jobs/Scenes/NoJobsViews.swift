//
//  NoJobsViews.swift
//  Jobs
//
//  Created by Rui Silva on 12/02/2025.
//

import SwiftUI

struct NoJobsViews: View {
    var body: some View {
        VStack {
            Image(uiImage: .noJobsYet)
                .padding(.bottom, 32)
            Text("No Jobs Added Yet")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Tap '+' to save new jobs")
                .font(.callout)
                .fontWeight(.regular)
                .opacity(0.6)
        }
    }
}

#Preview {
    NoJobsViews()
}
