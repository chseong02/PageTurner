//
//  CalibrationView.swift
//  PageTurner
//
//  Created by chseong on 7/10/25.
//
//


import SwiftUI
import ARKit
import RealityKit

struct CalibrationView: View {
    @Binding var calibrationStep: Int
    @Binding var observations: [CGPoint]
    @Binding var calibrationData: CalibrationData?
    @Binding var eyeGazeActive: Bool
    @Binding var isCalibrating: Bool

    private let targetCount = 5

    // 뷰 전체에서 한 번만 생성되는 타이머 퍼블리셔
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()

    var targets: [CGPoint] {
        let w = Device.frameSize.width
        let h = Device.frameSize.height
        return [
            CGPoint(x: w * 0.05, y: h * 0.05),
            CGPoint(x: w * 0.95, y: h * 0.05),
            CGPoint(x: w * 0.95, y: h * 0.95),
            CGPoint(x: w * 0.05, y: h * 0.95),
            CGPoint(x: w * 0.5, y: h * 0.5)
        ]
    }

    var body: some View {
        ZStack {
            if calibrationStep < targetCount {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                    .position(targets[calibrationStep])
            } else {
//                Text("보정을 완료했습니다")
//                    .font(.title)
//                    .foregroundColor(.green)
            }
        }
        .onReceive(timer) { _ in
            guard calibrationStep < targetCount else {
                // 타이머 취소
                timer.upstream.connect().cancel()
                print("여기 도달하니?")
                computeCalibration()
                eyeGazeActive = true
                isCalibrating = false
                return
            }
            calibrationStep += 1
        }
        .onAppear {
            // 뷰가 나타날 때 isCalibrating 상태에 따라 타이머 재연결
            if isCalibrating {
                timer = Timer.publish(every: 3, on: .main, in: .common)
                    .autoconnect()
            }
        }
        .onDisappear {
            // 뷰가 사라질 때 타이머 취소
            timer.upstream.connect().cancel()
        }
    }

    private func computeCalibration() {
        print(observations.count)
        print(targetCount)
        //guard observations.count == targetCount else { return }
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

//import SwiftUI
//import ARKit
//import RealityKit
//
//struct CalibrationView: View {
//    @Binding var calibrationStep: Int
//    @Binding var observations: [CGPoint]
//    @Binding var calibrationData: CalibrationData?
//    @Binding var eyeGazeActive: Bool
//    @Binding var isCalibrating: Bool
//
//    private let targetCount = 5
//    private let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
//
//    var targets: [CGPoint] {
//        let w = Device.frameSize.width
//        let h = Device.frameSize.height
//        return [
//            CGPoint(x: w * 0.1, y: h * 0.1),
//            CGPoint(x: w * 0.9, y: h * 0.1),
//            CGPoint(x: w * 0.9, y: h * 0.9),
//            CGPoint(x: w * 0.1, y: h * 0.9),
//            CGPoint(x: w * 0.5, y: h * 0.5)
//        ]
//    }
//
//    var body: some View {
//        ZStack {
//            // semi-transparent background
////            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
//            // calibration target
//            if calibrationStep < targetCount {
//                Circle()
//                    .stroke(Color.white, lineWidth: 3)
//                    .frame(width: 40, height: 40)
//                    .position(targets[calibrationStep])
//            } else {
//                Text("Calibration Complete!")
//                    .font(.title)
//                    .foregroundColor(.green)
//            }
//        }
//        .onReceive(timer) { _ in
//            print("확인")
//            if calibrationStep < targetCount {
//                calibrationStep += 1
//            } else {
//                timer.upstream.connect().cancel()
//                computeCalibration()
//                eyeGazeActive = true
//                isCalibrating = false
//            }
//        }
//    }
//
//    private func computeCalibration() {
//        guard observations.count == targetCount else { return }
//        let rawXs = observations.map { $0.x }
//        let rawYs = observations.map { $0.y }
//        let tgtXs = targets.map { $0.x }
//        let tgtYs = targets.map { $0.y }
//
//        let minRawX = rawXs.min()!, maxRawX = rawXs.max()!
//        let minRawY = rawYs.min()!, maxRawY = rawYs.max()!
//        let minTgtX = tgtXs.min()!, maxTgtX = tgtXs.max()!
//        let minTgtY = tgtYs.min()!, maxTgtY = tgtYs.max()!
//
//        let xScale = (maxTgtX - minTgtX) / (maxRawX - minRawX)
//        let xOffset = minTgtX - minRawX * xScale
//        let yScale = (maxTgtY - minTgtY) / (maxRawY - minRawY)
//        let yOffset = minTgtY - minRawY * yScale
//
//        calibrationData = CalibrationData(
//            xScale: xScale,
//            xOffset: xOffset,
//            yScale: yScale,
//            yOffset: yOffset
//        )
//    }
//}
