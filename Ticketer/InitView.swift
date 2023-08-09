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
                    .background(Color.red) // Set background color to indicate camera view

                Button("Save", action: {
                    // Perform save action based on selected tier
                    switch selectedTier {
                        case 0:
                            // Save for Tier 1
                            break
                        case 1:
                            // Save for Tier 2
                            break
                        case 2:
                            // Save for Tier 3
                            break
                        default:
                            break
                    }
                })
                .padding()
            }
            .navigationBarTitle("Init QR code", displayMode: .inline) // Clear the title and set display mode to inline
        }
        .onAppear {
            qrCodeScannerModel.setupCaptureSession()
        }
    }
}
