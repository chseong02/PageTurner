//
//  CustomARViewContainer.swift
//  PageTurner
//
//  Created by chseong on 7/10/25.
//

import SwiftUI
import ARKit
import RealityKit

struct CustomARViewContainer: UIViewRepresentable {
    @Binding var eyeGazeActive: Bool
    @Binding var lookAtPoint: CGPoint?
    @Binding var isWinking: Bool
    @Binding var calibrationStep: Int
    @Binding var observations: [CGPoint]
    @Binding var calibrationData: CalibrationData?

    func makeUIView(context: Context) -> CustomARView {
        CustomARView(
            eyeGazeActive: $eyeGazeActive,
            lookAtPoint: $lookAtPoint,
            isWinking: $isWinking,
            calibrationStep: $calibrationStep,
            observations: $observations,
            calibrationData: $calibrationData
        )
    }
    func updateUIView(_ uiView: CustomARView, context: Context) {}
}

class CustomARView: ARView, ARSessionDelegate {
    @Binding var eyeGazeActive: Bool
    @Binding var lookAtPoint: CGPoint?
    @Binding var isWinking: Bool
    @Binding var calibrationStep: Int
    @Binding var observations: [CGPoint]
    @Binding var calibrationData: CalibrationData?

    init(
        eyeGazeActive: Binding<Bool>,
        lookAtPoint: Binding<CGPoint?>,
        isWinking: Binding<Bool>,
        calibrationStep: Binding<Int>,
        observations: Binding<[CGPoint]>,
        calibrationData: Binding<CalibrationData?>
    ) {
        _eyeGazeActive = eyeGazeActive
        _lookAtPoint = lookAtPoint
        _isWinking = isWinking
        _calibrationStep = calibrationStep
        _observations = observations
        _calibrationData = calibrationData

        super.init(frame: .zero)
        commonInit()
    }

    @MainActor required dynamic init?(coder decoder: NSCoder) { fatalError() }
    @MainActor required dynamic init(frame frameRect: CGRect) { fatalError() }

    private func commonInit() {
        debugOptions = []
        //debugOptions = [.showAnchorOrigins]
        session.delegate = self
        session.run(ARFaceTrackingConfiguration())
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let face = anchors.compactMap({ $0 as? ARFaceAnchor }).first else { return }
        // collect raw points during calibration
        if calibrationStep < 5 {
            let raw = computeRawPoint(from: face)
            DispatchQueue.main.async { [weak self] in
                self?.observations.append(raw)
            }
            return
        }
        // apply calibration in tracking mode
        if eyeGazeActive {
            let raw = computeRawPoint(from: face)
            let final = calibrationData?.calibrated(raw) ?? raw
            DispatchQueue.main.async { [weak self] in
                self?.lookAtPoint = final
            }
        }
    }

    private func computeRawPoint(from face: ARFaceAnchor) -> CGPoint {
        let look = face.lookAtPoint
        guard let cam = session.currentFrame?.camera.transform else { return .zero }
        let world = face.transform * simd_float4(look, 1)
        let camSpace = simd_mul(simd_inverse(cam), world)

        let rawX = camSpace.y / (Float(Device.screenSize.width)/2) * Float(Device.frameSize.width)
        let rawY = camSpace.x / (Float(Device.screenSize.height)/2) * Float(Device.frameSize.height)
        return CGPoint(x: CGFloat(rawX), y: CGFloat(rawY))
            .clamped(xRange: Ranges.widthRange, yRange: Ranges.heightRange)
    }
}
