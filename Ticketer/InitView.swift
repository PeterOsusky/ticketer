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

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Tier", selection: $selectedTier) {
                    Text("Tier 1").tag(0)
                    Text("Tier 2").tag(1)
                    Text("Tier 3").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())

                Text("Detected QR Code: \(qrCodeScannerModel.detectedQRCode)")
                QRCodeScannerView(qrCodeScannerModel: qrCodeScannerModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                
                Button("Save") {
                    // Perform save action based on QR code detection
                    if qrCodeScannerModel.detectedQRCode != "" {
                        // Save the detected QR code
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
}
