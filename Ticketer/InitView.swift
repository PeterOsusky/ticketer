//
//  TicketScannerView.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import SwiftUI
import CoreData

struct InitView: View {
    @StateObject private var qrCodeScannerModel = QRCodeScannerModel()
    @State private var selectedTier: Int = 0 // Selected tier: 0, 1, or 2
    @Environment(\.managedObjectContext) private var viewContext // Inject the managed object context
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .first

    enum ActiveAlert {
        case first, second
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Import vstupeniek")

                Picker("Select Tier", selection: $selectedTier) {
                    Text("Macka").tag(0)
                    Text("Shrimp").tag(1)
                    Text("Crab").tag(2)
                    Text("Shark").tag(3)
                    Text("Whale").tag(4)

                }
                .pickerStyle(SegmentedPickerStyle())

                Text("QR kod: \(qrCodeScannerModel.detectedQRCode)")
                QRCodeScannerView(qrCodeScannerModel: qrCodeScannerModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                
                Button("Uloz") {
                    // Perform save action based on QR code detection
                    if qrCodeScannerModel.detectedQRCode != "" {
                        saveTicket()
                    }
                }
                .padding()
                .foregroundColor(qrCodeScannerModel.detectedQRCode != "" ? .green : .red)
                .disabled(qrCodeScannerModel.detectedQRCode != "" ? false : true)

                
            }
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .first:
                    return Alert(title: Text("Chyba"), message: Text("Vstupenka uz je v databaze."), dismissButton: .default(Text("OK")))
                case .second:
                    return Alert(title: Text("OK"), message: Text("Vstupenka pridana."), dismissButton: .default(Text("OK")))
                }
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
    
    private func saveTicket() {
        let qrCodeValue = qrCodeScannerModel.detectedQRCode
        let ticketFetch: NSFetchRequest<TicketEntity> = TicketEntity.fetchRequest()
        ticketFetch.predicate = NSPredicate(format: "value == %@", qrCodeValue)

        do {
            let matchingTickets = try viewContext.fetch(ticketFetch)
            if matchingTickets.first != nil {
                // A ticket with the same value already exists
                showAlert = true
                self.activeAlert = .first

            } else {
                // Create and save the new ticket
                let newTicket = TicketEntity(context: viewContext)
                newTicket.number = PersistenceController.shared.getNextID()
                newTicket.value = qrCodeValue
                newTicket.tier = NSDecimalNumber(value: selectedTier)
                newTicket.isValid = true
                print(newTicket.number)
                showAlert = true
                self.activeAlert = .second

                try viewContext.save()
            }
        } catch {
            // Handle error
            print("Error saving ticket: \(error)")
        }
        qrCodeScannerModel.detectedQRCode = ""
    }
}
