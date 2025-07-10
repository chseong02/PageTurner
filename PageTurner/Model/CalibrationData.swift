//
//  CalibrationData.swift
//  PageTurner
//
//  Created by chseong on 7/10/25.
//

import Foundation

struct CalibrationData: Codable, Equatable {
    let xScale: CGFloat
    let xOffset: CGFloat
    let yScale: CGFloat
    let yOffset: CGFloat
    
    
    /// raw 포커스 → 보정된 화면 좌표
    func calibrated(_ raw: CGPoint) -> CGPoint {
        let x = raw.x * xScale + xOffset
        let y = raw.y * yScale + yOffset
        return CGPoint(x: x, y: y)
    }
}

extension CGPoint {
    func clamped(xRange: ClosedRange<CGFloat>, yRange: ClosedRange<CGFloat>) -> CGPoint {
        CGPoint(
            x: x.clamped(to: xRange),
            y: y.clamped(to: yRange)
        )
    }
}
