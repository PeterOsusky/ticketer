//
//  Scanview.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import Foundation
import SwiftUI
import CoreData

struct ScanView: View {
    @StateObject private var qrCodeScannerModel = QRCodeScannerModel()
    @Environment(\.managedObjectContext) private var viewContext // Inject the managed object context
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var tier = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("QR kod: \(qrCodeScannerModel.detectedQRCode)")
                Text("Tier: \(tier)")
                QRCodeScannerView(qrCodeScannerModel: qrCodeScannerModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                
                Button("Vstup") {
                    // Perform save action based on QR code detection
                    if qrCodeScannerModel.detectedQRCode != "" {
                        loadTicket()
                    }
                }
                .padding()
                .foregroundColor(qrCodeScannerModel.detectedQRCode != "" ? .green : .red)
                .disabled(qrCodeScannerModel.detectedQRCode != "" ? false : true)

                
            }
            .navigationBarTitle("Kontrola vstupeniek", displayMode: .inline) // Clear the title and set display mode to inline
            .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        }
        .onAppear {
            qrCodeScannerModel.setupCaptureSession()
        }
        .onDisappear {
            qrCodeScannerModel.captureSession?.stopRunning()
            qrCodeScannerModel.detectedQRCode = "" // Reset the detectedQRCode
        }
    }
    
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
    
    private func loadTicket() {
        let qrCodeToCheck = qrCodeScannerModel.detectedQRCode
        let ticketFetch: NSFetchRequest<TicketEntity> = TicketEntity.fetchRequest()
        ticketFetch.predicate = NSPredicate(format: "value == %@", qrCodeToCheck)
        
        do {
            let matchingTickets = try viewContext.fetch(ticketFetch)
            if let matchingTicket = matchingTickets.first {
                if matchingTicket.isValid {
                    matchingTicket.isValid = false // Set isValid to false
                    matchingTicket.timestamp = Date()
                    try viewContext.save() // Save the change
                    alertTitle = "Ok"
                    alertMessage = "Vstupenka je v poriadku."
                    showAlert = true // Show the alert
                    tier = tierString(for: matchingTicket.tier as! Int) 
                } else {
                    let formattedTimestamp = dateFormatter.string(from: matchingTicket.timestamp!)
                    alertTitle = "Chyba"
                    alertMessage = "Vstupenka bola uplatnena \(formattedTimestamp)."
                    showAlert = true // Show the alert
                }
            } else {
                alertTitle = "Chyba"
                alertMessage = "Neplatna vstupenka"
                showAlert = true // Show the alert
            }
        } catch {
            print("Error fetching matching ticket: \(error)")
        }
    }
    
}
