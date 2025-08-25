//
//  LocationTypeView.swift
//  Jobs
//
//  Created by Rui Silva on 25/08/2025.
//

import SwiftUI

struct LocationTypeView: View {
    
    @Binding private var locationType: LocationType
    @Binding private var location: String
    @Binding private var workingDays: [String]
    
    private let workingDaysToSave: [String]
    
    public init(locationType: Binding<LocationType>,
                location: Binding<String>,
                workingDays: Binding<[String]>,
                workingDaysToSave: [String]) {
        self._locationType = locationType
        self._location = location
        self._workingDays = workingDays
        self.workingDaysToSave = workingDaysToSave
    }
    
    var body: some View {
        Section {
            Picker("Job Type", selection: $locationType.animation()) {
                ForEach(LocationType.allCases, id: \.self) { location in
                    Text(location.type).tag(location)
                }
            }
            
            if locationType != .remote {
                TextfieldWithSFSymbol(text: $location, placeholder: "Location", systemName: "mappin")
                WorkingDaysView(workingDays: $workingDays, workingDaysToSave: workingDaysToSave)
            }
        }
    }
}
