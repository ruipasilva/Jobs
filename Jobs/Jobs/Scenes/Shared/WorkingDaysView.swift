//
//  WorkingDaysView.swift
//  Jobs
//
//  Created by Rui Silva on 09/07/2024.
//

import SwiftUI

struct WorkingDaysView: View {
    
    @Binding private var workingDays: [String]
    
    private let workingDaysToSave: [String]
    
    public init(workingDays: Binding<[String]>,
                workingDaysToSave: [String]) {
        self._workingDays = workingDays
        self.workingDaysToSave = workingDaysToSave
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(workingDaysToSave, id: \.self) { item in
                VStack(alignment: .center) {
                    Text(item)
                        .padding(.bottom, 2)
                    Button(action: {
                        let index = workingDays.firstIndex(of: item)
                        if workingDays.contains(item) {
                            workingDays.remove(at: index!)
                        } else {
                            workingDays.append(item)
                        }
                    }, label: {
                        Image(systemName: workingDays.contains(item) ? "checkmark.circle.fill" : "circle")
                            .imageScale(.large)
                            .foregroundStyle(
                                workingDays.contains(item) ? Color.accentColor : Color(uiColor: .tertiaryLabel))
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
