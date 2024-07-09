//
//  WorkingDaysView.swift
//  Jobs
//
//  Created by Rui Silva on 09/07/2024.
//

import SwiftUI

struct WorkingDaysView: View {
    
    @Binding private var workingDaysToSave: [String]
    
    private let workingDays: [String]
    
    public init(workingDaysToSave: Binding<[String]>,
                workingDays: [String]) {
        self._workingDaysToSave = workingDaysToSave
        self.workingDays = workingDays
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(workingDays, id: \.self) { item in
                VStack(alignment: .center) {
                    Text(item)
                        .padding(.bottom, 2)
                    Button(action: {
                        let index = workingDaysToSave.firstIndex(of: item)
                        if workingDaysToSave.contains(item) {
                            workingDaysToSave.remove(at: index!)
                        } else {
                            workingDaysToSave.append(item)
                        }
                    }, label: {
                        Image(systemName: workingDaysToSave.contains(item) ? "checkmark.circle.fill" : "circle")
                            .imageScale(.large)
                            .foregroundStyle(workingDaysToSave.contains(item) ? Color.accentColor : Color(uiColor: .tertiaryLabel))
                    })
                    .buttonStyle(.plain)
                    .tint(.accentColor)
                }
                .padding(.vertical, 4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
