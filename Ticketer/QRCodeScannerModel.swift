//
//  QRCodeScannerModel.swift
//  Ticketer
//
//  Created by Peter on 09/08/2023.
//

import AVFoundation
import Combine

class QRCodeScannerModel: NSObject, AVCaptureMetadataOutputObjectsDelegate, ObservableObject {
    var captureSession: AVCaptureSession?
    @Published var detectedQRCode: String = ""
    
    func setupCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }

            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                self.captureSession = AVCaptureSession()
                self.captureSession?.addInput(input)

                let captureMetadataOutput = AVCaptureMetadataOutput()
                self.captureSession?.addOutput(captureMetadataOutput)

                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [.qr]

                self.captureSession?.startRunning()
            } catch {
                print(error)
            }
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let qrCodeValue = metadataObj.stringValue {
            detectedQRCode = qrCodeValue
        }
    }
}
