//
//  Ticket.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import Foundation

struct Ticket: Identifiable {
    let id: Int
    let qrCode: String
    var tier: TicketTier
    var isValid: Bool
}

enum TicketTier: String {
    case tier1 = "Tier 1"
    case tier2 = "Tier 2"
    case tier3 = "Tier 3"
}
