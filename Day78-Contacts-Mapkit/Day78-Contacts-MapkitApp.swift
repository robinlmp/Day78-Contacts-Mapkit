//
//  Day78_ContactsApp.swift
//  Day78-Contacts
//
//  Created by Robin Phillips on 18/08/2021.
//

import SwiftUI

@main
struct Day78ContactsMapkitApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(settings: Settings())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
