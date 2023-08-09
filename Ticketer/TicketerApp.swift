//
//  TicketerApp.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import SwiftUI

@main
struct TicketerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
