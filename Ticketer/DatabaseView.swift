//
//  DatabaseView.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import SwiftUI
import CoreData

struct DatabaseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TicketEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \TicketEntity.timestamp, ascending: false)])
    private var fetchedTickets: FetchedResults<TicketEntity>
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    private func deleteTicket(at offsets: IndexSet) {
        for offset in offsets {
            let ticketToDelete = fetchedTickets[offset]
            viewContext.delete(ticketToDelete)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error deleting ticket: \(error)")
        }
    }
    
    var body: some View {
        NavigationView {
            if fetchedTickets.isEmpty {
                Text("No tickets available")
                    .navigationBarTitle("Database")
            } else {
                List {
                    ForEach(fetchedTickets, id: \.self) { ticket in
                        VStack(alignment: .leading) {
                            Text("ID: \(ticket.number)")
                            Text(ticket.value!)
                            Text("Kategoria: \(tierString(for: Int(ticket.tier?.intValue ?? 0)))")
                            if !ticket.isValid {
                                Text("Uplatneny: \(ticket.timestamp!, formatter: dateFormatter)")
                            }
                        }
                        .listRowBackground(ticket.isValid ? Color.green : Color.red)
                    }
                    .onDelete(perform: deleteTicket)
                }
            }
        }
    }
}

struct DatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        return DatabaseView().environment(\.managedObjectContext, context)
    }
}
