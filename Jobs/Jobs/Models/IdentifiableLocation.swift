//
//  IdentifiableLocation.swift
//  Jobs
//
//  Created by Rui Silva on 28/01/2025.
//

import Foundation
import MapKit

public class IdentifiableLocation: Identifiable {
    public let id = UUID()
    public var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
