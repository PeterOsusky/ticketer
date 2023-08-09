//
//  DatabaseView.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import Foundation
import SwiftUI

struct DatabaseView: View {
    var tickets: [Ticket] = [
        // Populate with your actual ticket data
    ]
    
    var body: some View {
        NavigationView {
            if tickets.isEmpty {
                Text("No tickets available")
                    .navigationBarTitle("Database")
            } else {
                List(tickets) { ticket in
                    VStack(alignment: .leading) {
                        Text("Ticket ID: \(ticket.id)")
                        Text("QR Code: \(ticket.qrCode)")
                        Text("Tier: \(ticket.tier.rawValue)")
                    }
                }
                .navigationBarTitle("Database")
            }
        }
    }
}

struct DatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseView()
    }
}


