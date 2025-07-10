//
//  EyeTrackingCalibrationView.swift
//  PageTurner
//
//  Created by chseong on 7/10/25.
//

import SwiftUI
import ARKit
import RealityKit

struct EyeTrackingCalibrationView: View {
    @State private var calibrationStep = 0
    @State private var observations: [CGPoint] = []
    @State private var calibrationData: CalibrationData?
    @Binding var eyeGazeActive: Bool
    @Binding var lookAtPoint: CGPoint?
    @Binding var isWinking: Bool

    /// 화면 상 보정용 타깃 위치들 (예: 4모서리 + 중앙)
    private var targets: [CGPoint] {
        let w = Device.frameSize.width
        let h = Device.frameSize.height
        return [
            CGPoint(x: w * 0.1, y: h * 0.1),
            CGPoint(x: w * 0.9, y: h * 0.1),
            CGPoint(x: w * 0.9, y: h * 0.9),
            CGPoint(x: w * 0.1, y: h * 0.9),
            CGPoint(x: w * 0.5, y: h * 0.5),
        ]
    }

    var body: some View {
        ZStack {
            // 1) AR 뷰
            CustomARViewContainer(
                eyeGazeActive: $eyeGazeActive,
                lookAtPoint: $lookAtPoint,
                isWinking: $isWinking,
                calibrationStep: $calibrationStep,
                observations: $observations,
                calibrationData: $calibrationData
            )
            .edgesIgnoringSafeArea(.all)

            // 2) 보정 타깃: 현재 step에 해당하는 위치에 원 표시
            if calibrationStep < targets.count {
                Circle()
                    .stroke(lineWidth: 3)
                    .frame(width: 40, height: 40)
                    .position(targets[calibrationStep])
                    .onAppear {
                        // 타깃이 보여질 때 잠시 후에 raw observation을 기록하도록 알림
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            // CustomARView 세션 델리게이트에서 자동으로 observations에 append됨
                        }
                    }
            } else {
                Text("보정 완료!")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        .onChange(of: calibrationStep) { step in
            // 보정 점 5개가 모두 모이면 계수 계산
            if step == targets.count {
                computeCalibration()
                eyeGazeActive = true
            }
        }
    }

    private func computeCalibration() {
        let rawXs = observations.map { $0.x }
        let rawYs = observations.map { $0.y }
        let tgtXs = targets.map { $0.x }
        let tgtYs = targets.map { $0.y }

        let minRawX = rawXs.min()!, maxRawX = rawXs.max()!
        let minRawY = rawYs.min()!, maxRawY = rawYs.max()!
        let minTgtX = tgtXs.min()!, maxTgtX = tgtXs.max()!
        let minTgtY = tgtYs.min()!, maxTgtY = tgtYs.max()!

        let xScale = (maxTgtX - minTgtX) / (maxRawX - minRawX)
        let xOffset = minTgtX - minRawX * xScale
        let yScale = (maxTgtY - minTgtY) / (maxRawY - minRawY)
        let yOffset = minTgtY - minRawY * yScale

        calibrationData = CalibrationData(
            xScale: xScale,
            xOffset: xOffset,
            yScale: yScale,
            yOffset: yOffset
        )
    }
}
