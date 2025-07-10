//
//  ContentView.swift
//  PageTurner
//
//  Created by chseong on 7/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var appViewModel: ScoreViewModel
    @State private var eyeGazeActive = false
    @State private var lookAtPoint: CGPoint? = nil
    @State private var isWinking = false
    
    @State private var isCalibrating = false
    @State private var calibrationStep = 0
    @State private var observations: [CGPoint] = []
    @State private var calibrationData: CalibrationData? = nil
    
    
    init(modelContext: ModelContext) {
        _appViewModel = StateObject(wrappedValue: ScoreViewModel(modelContext: modelContext))
        print(UIScreen.main.nativeBounds.width)
        print(UIScreen.main.nativeBounds.height)
    }
    var body: some View {
        NavigationSplitView {
            ScorePageLeftSideView().environmentObject(appViewModel)
        } detail: {
            //            ZStack {
            //                // AR + gaze tracking
            //                CustomARViewContainer(
            //                    eyeGazeActive: $eyeGazeActive,
            //                    lookAtPoint: $lookAtPoint,
            //                    isWinking: $isWinking,
            //                    calibrationStep: $calibrationStep,
            //                    observations: $observations,
            //                    calibrationData: $calibrationData
            //                )
            //                .edgesIgnoringSafeArea(.all)
            //
            //                // Visualize gaze point
            //                if let pt = lookAtPoint, !isCalibrating {
            //                    Circle()
            //                        .fill(Color.red.opacity(0.5))
            //                        .frame(width: 30, height: 30)
            //                        .position(pt)
            //                }
            //
            //                // Calibration overlay
            //                if isCalibrating {
            //                    CalibrationView(
            //                        calibrationStep: $calibrationStep,
            //                        observations: $observations,
            //                        calibrationData: $calibrationData,
            //                        eyeGazeActive: $eyeGazeActive,
            //                        isCalibrating: $isCalibrating
            //                    )
            //                }
            //            }
            //            .navigationTitle("Eye Tracker")
            //            .toolbar {
            //                ToolbarItem(placement: .navigationBarTrailing) {
            //                    Button(isCalibrating ? "Cancel" : "Calibrate") {
            //                        if isCalibrating {
            //                            isCalibrating = false
            //                        } else {
            //                            // reset and start calibration
            //                            calibrationStep = 0
            //                            observations.removeAll()
            //                            eyeGazeActive = false
            //                            isCalibrating = true
            //                        }
            //                    }
            //                }
            //            }
            //        }
            //            CalibrationView(eyeGazeActive: $eyeGazeActive, lookAtPoint: $lookAtPoint, isWinking: $isWinking).toolbar {
            //                ToolbarItem(placement: .navigationBarTrailing) {
            //                    Button("Calibrate") {
            //                    }
            //                }
            //            }
            ScorePageMainView().environmentObject(appViewModel)
        }
    }
}

#Preview {
    let container = try! ModelContainer(
      for: Score.self, Item.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    ContentView(modelContext: container.mainContext)
        .modelContainer(for: Item.self, inMemory: true)
}
