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
    
    // Function to get the latest ID value and update it
    func getNextID() -> Int64 {
        let context = container.viewContext
        let counterFetch: NSFetchRequest<CounterEntity> = CounterEntity.fetchRequest()
        
        do {
            let counters = try context.fetch(counterFetch)
            if let counter = counters.first {
                let nextID = counter.latestID
                counter.latestID += 1
                try context.save()
                return nextID
            } else {
                let newCounter = CounterEntity(context: context)
                newCounter.latestID = 2 // Start with 2 for the first ticket
                try context.save()
                return 1 // Return 1 for the first ticket ID
            }
        } catch {
            fatalError("Error fetching counters: \(error)")
        }
    }
    
}
