//
//  PersistenceController.swift
//  Ticketer
//
//  Created by Peter on 09/08/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Ticket") // Replace "YourAppName" with your actual Core Data model name
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
