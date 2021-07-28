//
//  CGPath.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-02-05.
//

import SwiftUI

extension CGPath {
    var points: [String:Int] {
        var arrPoints: [String:Int] = [:]
        var move: [CGPoint] = []
        var line: [CGPoint] = []
        var quad: [CGPoint] = []
        var curv: [CGPoint] = []
        self.applyWithBlock { element in
            switch element.pointee.type {
                case .moveToPoint:
                    move.append(element.pointee.points.pointee)
                case .addLineToPoint:
                    line.append(element.pointee.points.pointee)
                case .addQuadCurveToPoint:
                    quad.append(element.pointee.points.pointee)
                    quad.append(element.pointee.points.advanced(by: 1).pointee)
                case .addCurveToPoint:
                    curv.append(element.pointee.points.pointee)
                    curv.append(element.pointee.points.advanced(by: 1).pointee)
                    curv.append(element.pointee.points.advanced(by: 2).pointee)
                default:
                    break
            }
        }
        arrPoints["move"] = move.count
        arrPoints["line"] = line.count
        arrPoints["quad"] = quad.count
        arrPoints["curv"] = curv.count
        return arrPoints
    }
}
