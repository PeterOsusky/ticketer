//
//  TicketScannerView.swift
//  Ticketer
//
//  Created by Peter on 08/08/2023.
//

import SwiftUI

struct InitView: View {
    @StateObject private var qrCodeScannerModel = QRCodeScannerModel()
    @State private var selectedTier: Int = 0 // Selected tier: 0, 1, or 2
    @Environment(\.managedObjectContext) private var viewContext // Inject the managed object context


    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Tier", selection: $selectedTier) {
                    Text("Tier 1").tag(0)
                    Text("Tier 2").tag(1)
                    Text("Tier 3").tag(2)
                    Text("Tier 4").tag(3)
                    Text("Tier 5").tag(4)

                }
                .pickerStyle(SegmentedPickerStyle())

                Text("Detected QR Code: \(qrCodeScannerModel.detectedQRCode)")
                QRCodeScannerView(qrCodeScannerModel: qrCodeScannerModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                
                Button("Save") {
                    // Perform save action based on QR code detection
                    if qrCodeScannerModel.detectedQRCode != "" {
                        saveTicket()                        
                    }
                }
                .padding()
                .foregroundColor(qrCodeScannerModel.detectedQRCode != "" ? .green : .red)
                .disabled(qrCodeScannerModel.detectedQRCode != "" ? false : true)

                
            }
            .navigationBarTitle("Init QR code", displayMode: .inline) // Clear the title and set display mode to inline
        }
        .onAppear {
            qrCodeScannerModel.setupCaptureSession()
        }
    }
    
    private func saveTicket() {
        withAnimation {
            let newTicket = TicketEntity(context: viewContext)
//            newTicket.id = PersistenceController.shared.getNextID()
            newTicket.value = qrCodeScannerModel.detectedQRCode
            newTicket.tier = NSDecimalNumber(value: selectedTier)
            newTicket.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Handle error
                print("Error saving ticket: \(error)")
            }
        }
    }
    
}
