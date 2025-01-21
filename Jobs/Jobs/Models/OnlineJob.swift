//
//  OnlineJob.swift
//  Jobs
//
//  Created by Rui Silva on 20/01/2025.
//

import Foundation

public struct OnlineJobsResults: Decodable {
    let hits: [OnlineJob]
}

public struct OnlineJob: Decodable {
    let url: String
    let country: String
//    let city: String?
//    let description: String?
    let title: String
//    let publishedUntil: String?
//    let employmentType: String?
}




