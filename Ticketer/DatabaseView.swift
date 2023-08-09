//
//  DatabaseView.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import SwiftUI
import CoreData // Don't forget to import CoreData

struct DatabaseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: TicketEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \TicketEntity.timestamp, ascending: false)]) // Fetch and sort by timestamp
    private var fetchedTickets: FetchedResults<TicketEntity>
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationView {
            if fetchedTickets.isEmpty {
                Text("No tickets available")
                    .navigationBarTitle("Database")
            } else {
                List(fetchedTickets, id: \.self) { ticket in
                    VStack(alignment: .leading) {
                        Text("Ticket ID: \(ticket.id!)")
                        Text(ticket.value!)
                        Text("Tier: \(ticket.tier?.stringValue ?? "")")
                        Text("Timestamp: \(ticket.timestamp!, formatter: dateFormatter)")
                    }
                }
                .navigationBarTitle("Database")
            }
        }
    }
}

struct DatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared // Replace with your PersistenceController instance
        let context = persistenceController.container.viewContext
        return DatabaseView().environment(\.managedObjectContext, context)
    }
}


