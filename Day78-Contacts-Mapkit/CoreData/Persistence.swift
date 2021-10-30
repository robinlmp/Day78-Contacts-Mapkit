//
//  Persistence.swift
//  Day78-Contacts
//
//  Created by Robin Phillips on 18/08/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let lastNames = ["Johnson", "Potter", "Smith", "Bootle", "Kahn", "Cook", "Jackson"]
        let firstNames = ["Alex", "Sam", "Jo", "Frank", "Sarah", "Ellie", "Lucy"]
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Person(context: viewContext)
            newItem.dateAdded = Date()
            newItem.id = UUID()
            newItem.lastName = lastNames.randomElement()
            newItem.firstName = firstNames.randomElement()
        }
        do {
            viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    
    

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Day78-Contacts-Mapkit")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
