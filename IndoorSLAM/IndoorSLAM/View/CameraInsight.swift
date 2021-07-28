//
//  CameraInsight.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-01-23.
//

import SwiftUI
import AVFoundation

struct CameraInsight: View {
    
    @StateObject var detection: ObjectDetection
    @StateObject var contours: ContourDetection
    @State private var startCapture = false
    @State private var segmentIndex = 0
    @State private var segmentElements = ["Insight", "Mapping"]
    
    var body: some View {
        VStack (alignment: .center, spacing: 0, content: {
            Picker(selection: $segmentIndex, label: Text("Picker"), content: {
                ForEach(0 ..< segmentElements.count) { index in
                    Text(self.segmentElements[index]).tag(index)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
            if (segmentIndex == 0) {
                VStack (alignment: .center, spacing: 10, content: {
                    HStack (alignment: .firstTextBaseline, spacing: 20, content: {
                        Spacer(minLength: UIScreen.main.bounds.width / 2)
                        Image(systemName: "play.fill")
                            .font(.headline)
                            .opacity(startCapture ? 0.3 : 0.9)
                            .onTapGesture(perform: {
                                self.detection.videoCaptureStarting()
                                self.startCapture = true
                            })
                        Image(systemName: "stop.fill")
                            .font(.headline)
                            .opacity(startCapture ? 0.9 : 0.3)
                            .onTapGesture(perform: {
                                self.detection.videoCaptureRemoving()
                                self.detection.detectionOverlay.removeFromSuperlayer()
                                self.detection.videoCapturePreview.removeFromSuperlayer()
                                self.startCapture = false
                            })
                        Spacer(minLength: 0)
                    })
                    if startCapture {
                        ZStack (alignment: .bottomTrailing, content: {
                            DetectionLayer(detection: detection)
                                .frame(width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height*0.75,
                                       alignment: .center)
                            HStack (alignment: .bottom, spacing: 5, content: {
                                Button (action: {
                                    contours.photoCaptureConfiguration()
                                    contours.photoCaptureSession.startRunning()
                                    contours.toTakePicture()
                                    contours.toDetectVisionContours(direction: RotationDegree.turnLeft, object: detection.object)
                                }, label: {
                                    ZStack (alignment: .center, content: {
                                        Image(systemName: "arrowtriangle.left.fill")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Rectangle.init()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color.black)
                                            .shadow(color: .gray, radius: 5, x: -1, y: 1)
                                            .cornerRadius(5)
                                            .opacity(0.3)
                                    })
                                })
                                Button (action: {
                                    
                                }, label: {
                                    ZStack (alignment: .center, content: {
                                        Image(systemName: "arrowtriangle.right.fill")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Rectangle.init()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color.black)
                                            .shadow(color: .gray, radius: 5, x: -1, y: 1)
                                            .cornerRadius(5)
                                            .opacity(0.3)
                                    })
                                })
                                Button (action: {
                                    
                                }, label: {
                                    ZStack (alignment: .center, content: {
                                        Image(systemName: "arrowtriangle.up.fill")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Rectangle.init()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color.black)
                                            .shadow(color: .gray, radius: 5, x: -1, y: 1)
                                            .cornerRadius(5)
                                            .opacity(0.3)
                                    })
                                })
                                Button (action: {
                                    
                                }, label: {
                                    ZStack (alignment: .center, content: {
                                        Image(systemName: "arrowtriangle.down.fill")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Rectangle.init()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color.black)
                                            .shadow(color: .gray, radius: 5, x: -1, y: 1)
                                            .cornerRadius(5)
                                            .opacity(0.3)
                                    })
                                })
                            })
                        })
                    } else {
                        Rectangle.init()
                            .frame(width: UIScreen.main.bounds.width,
                                   height: UIScreen.main.bounds.height*0.75,
                                   alignment: .center)
                            .foregroundColor(Color.black)
                    }
                    Text(startCapture ? "Keep Scanning" : "Do you want to start now?")
                        .font(.headline)
                        .fontWeight(.heavy)
                })
                .animation(.default)
                .transition(.move(edge: .leading))
                .padding()
            } else if (segmentIndex == 1) {
                VStack (alignment: .center, spacing: 0, content: {
                    Spacer(minLength: 0)
                    MappingPreview()
                    Spacer(minLength: 0)
                })
                .animation(.default)
                .transition(.move(edge: .leading))
                .padding()
            }
        }).onAppear(perform: detection.cameraAuthorizationStatus)
    }
}

struct DetectionLayer: UIViewRepresentable {
    
    // @ObservedObject var capture: CaptureModule
    @ObservedObject var detection: ObjectDetection
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height*0.75))
        detection.videoCapturePreview = AVCaptureVideoPreviewLayer(session: detection.videoCaptureSession)
        detection.videoCapturePreview.frame = view.frame
        detection.videoCapturePreview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(detection.videoCapturePreview)
        
        detection.DetectionFullSetup(view: view)
        
        detection.videoCaptureSession.startRunning()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}
