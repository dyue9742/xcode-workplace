#  IndoorSLAM Using the Built-in Camera

IndoorSLAM is an application inspired from Region-based CNN and FastSLAM 2.0 (Still in working).
This project is mainly composed of 3 parts: Extension, Model, View.

## Extension
It contains 3 different files, including extensions for standard library and general computing functions.
### ColorSet
```swift
// Add some nice color
struct ColorSet { ... }
```
### CGPath
```swift
// Obtain how many possible subpath a capture contains.
extension CGPath {
    var points: [String:Int] { ... }
}
```
### Computation
Jacobian Matrix; Gaussian Process; ELUs ...

## Model
It contains 6 different files, different classes for different tasks.
### Detection
Do detection for objects & contours asynchronously.
```swift
// Parent class, offer configuration of video capture and buffer size for display
class CaptureModule: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate { ... }
// Child class, embedded with YOLOv3 model
class ObjectDetection: CaptureModule { ... }
// Child class, use VNDetectContoursRequest
class ContourDetection: CaptureModule, AVCapturePhotoCaptureDelegate { ... }
```
### FastSLAM
Do pose estimation.
```swift
class FastSLAM { ... }
```
### Persistence
Store with Core Data

## View
it contains 4 different files.
In this app, we have 4 views: HomePage, Scanning, Mapping, Storage.
