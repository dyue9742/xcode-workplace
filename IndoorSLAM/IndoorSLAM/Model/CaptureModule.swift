//
//  CpatureModule.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-01-27.
//

import SwiftUI
import AVFoundation

class CaptureModule: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var bufferSize: CGSize = .zero
    
    @Published var videoCaptureSession = AVCaptureSession()
    @Published var videoCaptureOutputs = AVCaptureVideoDataOutput()
    @Published var videoCapturePreview: AVCaptureVideoPreviewLayer! = nil

    private let videoCaptureDataOutputQueue = DispatchQueue(label: "CaptureDataOutput",
                                                       qos: .userInitiated,
                                                       attributes: [],
                                                       autoreleaseFrequency: .workItem)
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    func cameraAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.videoCaptureConfiguration()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                self.videoCaptureConfiguration()
            }
            return
        case .restricted:
            return
        case .denied:
            return
        @unknown default:
            return
        }
    }
    
    func videoCaptureConfiguration() {
        var deviceInput: AVCaptureInput!
        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: device!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        videoCaptureSession.beginConfiguration()
        videoCaptureSession.sessionPreset = .high
        guard videoCaptureSession.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            videoCaptureSession.commitConfiguration()
            return
        }
        videoCaptureSession.addInput(deviceInput)
        if videoCaptureSession.canAddOutput(videoCaptureOutputs) {
            videoCaptureSession.addOutput(videoCaptureOutputs)
            videoCaptureOutputs.alwaysDiscardsLateVideoFrames = true
            videoCaptureOutputs.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoCaptureOutputs.setSampleBufferDelegate(self, queue: videoCaptureDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            videoCaptureSession.commitConfiguration()
            return
        }
        let captureConnection = videoCaptureOutputs.connection(with: .video)
        captureConnection?.isEnabled = true
        do {
            try  device!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((device?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            device!.unlockForConfiguration()
        } catch {
            print(error)
        }
        videoCaptureSession.commitConfiguration()
    }
    
    func videoCaptureStarting() {
        videoCaptureSession.startRunning()
    }
    
    func videoCaptureRemoving() {
        videoCaptureSession.stopRunning()
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:
            // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:
            // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:
            // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:
            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}
