//
//  StorageManager.swift
//  Jobs
//
//  Created by Rui Silva on 22/07/2025.
//

import Foundation
import SwiftData

public protocol StorageManaging {
    func save(context: ModelContext, job: Job)
    func delete(job: Job, context: ModelContext)
    func edit(initialJobTitle: String,
              initialCompanyName: String,
              jobTitle: inout String,
              jobCompany: inout String,
    )
}

class StorageManager: BaseViewModel, StorageManaging {
    
    func save(context: ModelContext, job: Job) {
        context.insert(job)
    }
    
    func delete(job: Job, context: ModelContext) {
        context.delete(job)
    }
    
    func edit(initialJobTitle: String,
              initialCompanyName: String,
              jobTitle: inout String,
              jobCompany: inout String) {
        if jobCompany.isEmpty || jobTitle.isEmpty {
            jobCompany = initialCompanyName
            jobTitle = initialJobTitle
        }
    }
    
}
