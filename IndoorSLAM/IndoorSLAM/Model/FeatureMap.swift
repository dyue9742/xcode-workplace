//
//  FeatureMap.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-02-06.
//

import SwiftUI

enum RotationDegree {
    case stayhere
    case goForward
    case goBackward
    case turnLeft
    case turnRight
}

struct Object {
    var identifier: String!
    var coordinate: CGPoint!
}

struct Measurement {
    var timeStamp: UInt64!
    var direction: RotationDegree!
    var pointsOfPath: [String:Int]!
    var palette: [[Int]]!
    var hasObject: Bool?
    var identifier: String?
    var coordinate: CGPoint?
}
