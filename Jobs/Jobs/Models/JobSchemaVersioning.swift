//
//  JobSchemaVersioning.swift
//  Jobs
//
//  Created by Rui Silva on 31/01/2026.
//

import SwiftData
import SwiftUI

// MARK: - Schema V1 (Current)
enum JobSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Job.self]
    }
}

// MARK: - Migration Plan
enum JobSchemaMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [JobSchemaV1.self]
    }

    static var stages: [MigrationStage] {
        // No migrations yet - this is the initial version
        // When you add V2, add migration stages here like:
        // migrateV1toV2
        []
    }

    // Example for future migrations:
    // static let migrateV1toV2 = MigrationStage.lightweight(
    //     fromVersion: JobSchemaV1.self,
    //     toVersion: JobSchemaV2.self
    // )
}
