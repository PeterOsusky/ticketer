//
//  QRCodeScannerEnvironment.swift
//  Ticketer
//
//  Created by Peter on 15/08/2023.
//

import Foundation
import AVFoundation

class QRCodeScannerEnvironment: ObservableObject {
    @Published var qrCodeScannerModel: QRCodeScannerModel

    init() {
        self.qrCodeScannerModel = QRCodeScannerModel()
    }
}
