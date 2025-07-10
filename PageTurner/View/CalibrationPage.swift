//
//  CalibrationPage.swift
//  PageTurner
//
//  Created by chseong on 7/10/25.
//

import SwiftUI

struct CalibrationPage: View {
    @EnvironmentObject var eyeTrackingViewModel: EyeTrackingViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            CustomARViewContainer(
                eyeGazeActive: $eyeTrackingViewModel.eyeGazeActive,
                lookAtPoint: $eyeTrackingViewModel.lookAtPoint,
                isWinking: $eyeTrackingViewModel.isWinking,
                calibrationStep: $eyeTrackingViewModel.calibrationStep,
                observations: $eyeTrackingViewModel.observations,
                calibrationData: $eyeTrackingViewModel.calibrationData
            )
            .edgesIgnoringSafeArea(.all)
            Color(.black)
            VStack {
                if(eyeTrackingViewModel.calibrationStep > 4){
                    Text("아이트래킹 보정을 완료했습니다")
                        .foregroundColor(.white)
                        .font(.title)
                }
                else {
                    Text("정확한 아이트래킹을 위한 준비 단계입니다")
                        .foregroundColor(.white)
                        .font(.title)
                    Text("화면에 표시되는 점에 시선을 집중하세요")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(.bottom, 16)
                }
                if(eyeTrackingViewModel.isBeforeCalibration)
                {
                    Button {
                        eyeTrackingViewModel.startCalibration()
                    } label: {
                        Text("시작")
                            .font(.title2)
                            .bold()
                            .frame(width: 100, height: 44)
                    }.buttonStyle(.borderedProminent)
                }
                else {
                    EmptyView().frame(width: 100,height: 60)
                }
            }
            if eyeTrackingViewModel.isCalibrating {
                CalibrationView(
                    calibrationStep: $eyeTrackingViewModel.calibrationStep,
                    observations: $eyeTrackingViewModel.observations,
                    calibrationData: $eyeTrackingViewModel.calibrationData,
                    eyeGazeActive: $eyeTrackingViewModel.eyeGazeActive,
                    isCalibrating: $eyeTrackingViewModel.isCalibrating
                )
            }
        }.ignoresSafeArea()
            .toolbar(removing:.sidebarToggle).navigationBarHidden(true)
            .onAppear{
                eyeTrackingViewModel.initialize()
            }
            .onChange(of: eyeTrackingViewModel.calibrationData) { data in
                if(data != nil){
                    print(data)
                    dismiss()
                }
                
            }
    }
}

#Preview {
    CalibrationPage()
}
