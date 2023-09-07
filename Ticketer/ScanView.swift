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
    @Environment(\.managedObjectContext) private var viewContext
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
                    if qrCodeScannerModel.detectedQRCode != "" {
                        loadTicket()
                    }
                }
                .padding()
                .foregroundColor(qrCodeScannerModel.detectedQRCode != "" ? .green : .red)
                .disabled(qrCodeScannerModel.detectedQRCode != "" ? false : true)
            }
            .navigationBarTitle("Kontrola vstupeniek", displayMode: .inline)
            .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        }
        .onAppear {
            qrCodeScannerModel.setupCaptureSession()
        }
        .onDisappear {
            qrCodeScannerModel.captureSession?.stopRunning()
            qrCodeScannerModel.detectedQRCode = ""
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    private func loadTicket() {
        let qrCodeToCheck = qrCodeScannerModel.detectedQRCode
        let ticketFetch: NSFetchRequest<TicketEntity> = TicketEntity.fetchRequest()
        ticketFetch.predicate = NSPredicate(format: "value == %@", qrCodeToCheck)
        
        do {
            let matchingTickets = try viewContext.fetch(ticketFetch)
            if let matchingTicket = matchingTickets.first {
                if matchingTicket.isValid {
                    matchingTicket.isValid = false
                    matchingTicket.timestamp = Date()
                    try viewContext.save()
                    alertTitle = "Ok"
                    alertMessage = "Vstupenka je v poriadku."
                    showAlert = true
                    tier = tierString(for: matchingTicket.tier as! Int) 
                } else {
                    let formattedTimestamp = dateFormatter.string(from: matchingTicket.timestamp!)
                    alertTitle = "Chyba"
                    alertMessage = "Vstupenka bola uplatnena \(formattedTimestamp)."
                    showAlert = true
                }
            } else {
                alertTitle = "Chyba"
                alertMessage = "Neplatna vstupenka"
                showAlert = true
            }
        } catch {
            print("Error fetching matching ticket: \(error)")
        }
    }
}
