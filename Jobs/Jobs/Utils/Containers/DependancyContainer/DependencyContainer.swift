//
//  DependencyContainer.swift
//  Jobs
//
//  Created by Rui Silva on 07/11/2024.
//

import Factory
import Foundation

extension Container {
    var notificationManager: Factory<NotificationManaging> {
        Factory(self) { NotificationManager() }
    }

    var calendarManager: Factory<CalendarManaging> {
        Factory(self) { CalendarManager() }
    }

    var networkManager: Factory<NetworkManaging> {
        Factory(self) { NetworkManager() }
    }
    
    var keychainManager: Factory<KeychainManaging> {
        Factory(self) { KeychainManager() }
    }
    
    var storageManager: Factory<StorageManaging> {
        Factory(self) { StorageManager() }
    }
}
