//
//  QRCodeScannerView.swift
//  Ticketer
//
//  Created by Peter on 09/08/2023.
//

import AVFoundation
import SwiftUI

struct QRCodeScannerView: UIViewRepresentable {
    @ObservedObject var qrCodeScannerModel: QRCodeScannerModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        DispatchQueue.main.async {
            if let captureSession = qrCodeScannerModel.captureSession {
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = view.bounds
                view.layer.addSublayer(previewLayer)
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
