//
//  ContourDetection.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-02-04.
//

import SwiftUI
import AVFoundation
import Vision

class ContourDetection: CaptureModule, AVCapturePhotoCaptureDelegate {
    
    @Published var photoCaptureSession = AVCaptureSession()
    @Published var photoCaptureOutputs = AVCapturePhotoOutput()
    @Published var measurement = [Measurement]()
    
    var imageData = Data(count: 0)
    
    // Configure the device; decide which camera is going to use; check input and output
    func photoCaptureConfiguration() {

        do{
            self.photoCaptureSession.beginConfiguration()
                        
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.photoCaptureSession.canAddInput(input){
                self.photoCaptureSession.addInput(input)
            }
            
            if self.photoCaptureSession.canAddOutput(self.photoCaptureOutputs){
                self.photoCaptureSession.addOutput(self.photoCaptureOutputs)
            }
            
            self.photoCaptureSession.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    // Take picture in the background of global queue
    func toTakePicture() {
        self.photoCaptureOutputs.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        self.photoCaptureSession.stopRunning()
    }
    
    // Here is a function from library. Store the image data
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil { return }
        guard let takenImage = photo.fileDataRepresentation() else { return }
        self.imageData = takenImage
    }
    
    // Detect Contours and also get the RGB data from the original image.
    func toDetectVisionContours(direction: RotationDegree, object: Object?) {
        if let capturedImage = UIImage(data: self.imageData)  {
            
            let palette = obtainZeroCenteredAndGrayscaledData(image: capturedImage)
            
            let inputImage = CIImage.init(cgImage: capturedImage.cgImage!)
            
            let contourRequest = VNDetectContoursRequest.init()
            contourRequest.contrastAdjustment = 1.0
            contourRequest.detectsDarkOnLight = true
            contourRequest.maximumImageDimension = 512
            
            let requestHandler = VNImageRequestHandler.init(ciImage: inputImage, options: [:])
            
            try! requestHandler.perform([contourRequest])
            let contoursObservation = contourRequest.results?.first as! VNContoursObservation
            
            let path = contoursObservation.normalizedPath.points
            
            let timeStamp = Date().timeIntervalSince1970.bitPattern
            
            let hasObject = (object != nil) ? true : false
            
            measurement.append(Measurement(timeStamp: timeStamp, direction: direction, pointsOfPath: path, palette: palette, hasObject: hasObject, identifier: object?.identifier, coordinate: object?.coordinate))
            print(measurement.first ?? "Not Gotten yet")
        } else {
            print("Could not load image.")
        }
        self.imageData = Data(count: 0)
    }
    
    // Return grayscaled RGB data.
    func obtainZeroCenteredAndGrayscaledData(image: UIImage) -> [[Int]] {
        var palette = [[Int]]()
        guard let cgImage = image.cgImage, let data = cgImage.dataProvider?.data, let bytes = CFDataGetBytePtr(data) else {
            fatalError("Couldn't access image data")
        }
        assert(cgImage.colorSpace?.model == .rgb)

        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        var sum: Int = 0
        var count: Int = 0
        for y in 0 ..< cgImage.height {
            var paletteRow = [Int]()
            for x in 0 ..< cgImage.width {
                let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                let components = (r: bytes[offset], g: bytes[offset + 1], b: bytes[offset + 2])
                // print("[x:\(x), y:\(y)] \(components)")
                var grayscale = 0.299 * Double(components.r)
                grayscale += 0.587 * Double(components.g)
                grayscale += 0.114 * Double(components.b)
                paletteRow.insert(Int(grayscale), at: x)
            }
            sum += paletteRow.reduce(0, +)
            count += paletteRow.count
            palette.insert(paletteRow, at: y)
        }
        let meanCol = Int(sum / count)
        var zeroCenteredPalette = [[Int]]()
        for y in 0 ..< palette.count {
            var zeroCenteredPaletteRow = [Int]()
            for x in 0 ..< palette[y].count {
                let subtracted = palette[y][x] - meanCol
                zeroCenteredPaletteRow.insert(subtracted, at: x)
            }
            zeroCenteredPalette.insert(zeroCenteredPaletteRow, at: y)
        }
        return zeroCenteredPalette
    }
}
