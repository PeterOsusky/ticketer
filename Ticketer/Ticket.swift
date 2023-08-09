//
//  Ticket.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import Foundation

struct Ticket: Identifiable {
    let id: Int
    let value: String
    var tier: Decimal
    var isValid: Bool
}
