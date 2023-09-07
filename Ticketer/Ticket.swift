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
    var number: Int64
}

func tierString(for index: Int) -> String {
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
