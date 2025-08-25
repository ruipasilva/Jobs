//
//  ApplicationStatusView.swift
//  Jobs
//
//  Created by Rui Silva on 23/08/2025.
//

import SwiftUI

struct ApplicationStatusView: View {
    
    @Binding private var applicationStatus: JobApplicationStatus
    @Binding private var aplicationStatusPrivate: String
    @Binding private var appliedDate: Date?
    
    var onChange: () -> Void
    
    public init(applicationStatus: Binding<JobApplicationStatus>,
                aplicationStatusPrivate: Binding<String>,
                appliedDate: Binding<Date?>,
                onChange: @escaping () -> Void) {
        self._applicationStatus = applicationStatus
        self._aplicationStatusPrivate = aplicationStatusPrivate
        self._appliedDate = appliedDate
        self.onChange = onChange
    }
    
    var body: some View {
        Section {
            Picker("Application Status", selection: $applicationStatus) {
                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                    Text(status.status).tag(status)
                }
            }
            /// Need to update jobApplicationStatusPrivate because #predicate used to count
            /// doesn't work with Enums
            /// Reminder: this is why this property exists
            .onChange(of: applicationStatus) { _, newValue in
                aplicationStatusPrivate = newValue.status
                onChange()
            }
            if applicationStatus != .notApplied {
                DatePicker("Application Date",
                           selection: Binding(
                            get: {
                                appliedDate ?? Date()
                            }, set: { appliedDate = $0 }),
                           displayedComponents: .date
                )
            }
        }
    }
}
