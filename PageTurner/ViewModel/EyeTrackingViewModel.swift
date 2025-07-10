//
//  EyeTrackingViewModel.swift
//  PageTurner
//
//  Created by chseong on 7/10/25.
//

import SwiftUI
import SwiftData


class EyeTrackingViewModel: ObservableObject {
    @Published var eyeGazeActive = false
    @Published var lookAtPoint: CGPoint? = nil
    @Published var isWinking = false

    @Published var isCalibrating = false
    @Published var calibrationStep = 0
    @Published var observations: [CGPoint] = []
    @Published var calibrationData: CalibrationData? = nil
    @Published var searchTerm: String = ""
    
//    let targetCount = 5
//    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    
    var calibrationTargets: [CGPoint] {
        let w = Device.frameSize.width
        let h = Device.frameSize.height
        return [
            CGPoint(x: w * 0.1, y: h * 0.1),
            CGPoint(x: w * 0.9, y: h * 0.1),
            CGPoint(x: w * 0.9, y: h * 0.9),
            CGPoint(x: w * 0.1, y: h * 0.9),
            CGPoint(x: w * 0.5, y: h * 0.5)
        ]
    }

    
    var isBeforeCalibration: Bool {
        return !isCalibrating && calibrationData == nil
    }
    private var modelContext: ModelContext?
    var context: ModelContext {
        return modelContext!
    }
    func initModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func startCalibration() {
        calibrationStep = 0
        observations.removeAll()
        eyeGazeActive = false
        isCalibrating = true
    }
    
    func initialize() {
        eyeGazeActive = false
        lookAtPoint = nil
        isWinking = false

        isCalibrating = false
        calibrationStep = 0
        observations = []
        calibrationData = nil
    }
}
