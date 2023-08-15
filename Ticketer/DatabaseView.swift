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
    
    private func tierString(for index: Int) -> String {
        switch index {
        case 0:
            return "Macka"
        case 1:
            return "Shrimp"
        case 2:
            return "Crab"
        case 3:
            return "Shark"
        case 4:
            return "Whale"
        default:
            return ""
        }
    }
    
    var body: some View {
        NavigationView {
            if fetchedTickets.isEmpty {
                Text("No tickets available")
                    .navigationBarTitle("Database")
            } else {
                List(fetchedTickets, id: \.self) { ticket in
                    VStack(alignment: .leading) {
                        Text("ID: \(ticket.number)")
                        Text(ticket.value!)
                        Text("Kategoria: \(tierString(for: Int(ticket.tier?.intValue ?? 0)))")
                        if !ticket.isValid {
                            Text("Uplatneny: \(ticket.timestamp!, formatter: dateFormatter)")
                        }
                        
                    }
                    .listRowBackground(ticket.isValid ? Color.green : Color.red) // Set background color based on isValid
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


