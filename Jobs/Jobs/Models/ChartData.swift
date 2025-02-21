//
//  ChartData.swift
//  Jobs
//
//  Created by Rui Silva on 21/02/2025.
//

import Foundation

public struct ChartData: Identifiable {
    public let id = UUID()
    let date: Date
    let count: Int
}
