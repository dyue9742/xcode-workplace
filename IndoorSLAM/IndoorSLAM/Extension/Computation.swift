//
//  Computation.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-02-01.
//

import SwiftUI

// Jacobian Matrix
func MatrixWithRotation(x: Double, y: Double, ro: RotationDegree) -> Array<Any> {
    if ro == .turnRight {
        let matrix = [
            [cos(Double.pi / 9), -sin(Double.pi / 9), x],
            [sin(Double.pi / 9),  cos(Double.pi / 9), y],
            [0,                   0,                  1]
        ]
        return matrix
    } else if ro == .turnLeft {
        let matrix = [
            [cos(-Double.pi / 9), -sin(-Double.pi / 9), x],
            [sin(-Double.pi / 9),  cos(-Double.pi / 9), y],
            [0,                   0,                    1]
        ]
        return matrix
    } else {
        let matrix = [
            [1, 0, x],
            [0, 1, y],
            [0, 0, 1]
        ]
        return matrix
    }
}

// Gaussian Function; return mean, sample variance and probabilities
func fGaussian(x: Array<Int>) -> (Double, Double, Array<Double>) {
    let sum = x.reduce(0, +)
    let m = Double(sum / x.count)
    var s: Double = 0.0
    for each in x {
        s += pow((Double(each) - m), 2)
    }
    s = s / Double(x.count)
    var prob: Array<Double> = []
    for each in x {
        let p = 1 / sqrt(2 * Double.pi * s) * exp(-0.5 * pow((Double(each) - m), 2) / s)
        prob.append(p)
    }
    return (m, s, prob)
}

// Exponential Linear Units (Activation Function)
func ELUs(measurement: Measurement) -> [[Double]] {
    var elus = [[Double]]()
    for y in 0 ..< measurement.palette.count {
        var elusRow = [Double]()
        for x in 0 ..< measurement.palette[y].count {
            if measurement.palette[y][x] > 0 {
                elusRow.insert(Double(measurement.palette[y][x]), at: x)
            } else {
                let new = (exp(Double(measurement.palette[y][x])) - 1) * 0.1
                elusRow.insert(new, at: x)
            }
        }
        elus.insert(elusRow, at: y)
    }
    return elus
}
