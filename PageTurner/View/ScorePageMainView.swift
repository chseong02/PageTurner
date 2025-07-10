//
//  ScorePageMainView.swift
//  PageTurner
//
//  Created by chseong on 7/4/25.
//

import SwiftUI
import SwiftData

struct ScorePageMainView: View {
    @State var isShownSheet: Bool = false
    @State var showRight: Bool = false
    @State private var inRangeSince: Date?
    @State private var inRangeSince2: Date?
    @EnvironmentObject var appViewModel: ScoreViewModel
    @StateObject private var eyeTrackingViewModel: EyeTrackingViewModel = EyeTrackingViewModel()
    var body: some View {
        VStack {
            if (appViewModel.existNoPDf || !appViewModel.isOpened) {
                Text("아직 악보가 없네요!\n새 악보를 추가해주세요")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Button{
                    isShownSheet = true
                }
                label: {
                    Text("악보 추가").font(.headline)
                }.buttonStyle(.borderedProminent)
            }
            else {
                ZStack {
                    if(eyeTrackingViewModel.eyeGazeActive){
                        CustomARViewContainer(
                            eyeGazeActive: $eyeTrackingViewModel.eyeGazeActive,
                            lookAtPoint: $eyeTrackingViewModel.lookAtPoint,
                            isWinking: $eyeTrackingViewModel.isWinking,
                            calibrationStep: $eyeTrackingViewModel.calibrationStep,
                            observations: $eyeTrackingViewModel.observations,
                            calibrationData: $eyeTrackingViewModel.calibrationData
                        )
                    }
//                                    .edgesIgnoringSafeArea(.all)
                    ScorePdfView(pdfUrl: appViewModel.score!.url).id(appViewModel.score!.url)
                        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onEnded { value in
                                print(value.translation)
                                switch(value.translation.width, value.translation.height) {
                                    case (...0, -50...50):  appViewModel.nextPage()
                                    case (0..., -50...50):  appViewModel.previousPage()
                                    case (-100...100, ...0):  print("up swipe")
                                    case (-100...100, 0...):  print("down swipe")
                                    default:  print("no clue")
                                }
                            }
                        ).trailingDrawer(isOpen: $showRight, width: 240) {
                            List {
                                ScoreRightSideView().listRowBackground(Color(.systemGray5))
                            }.listStyle(.plain)
                            .scrollContentBackground(.hidden)
                            .background(Color(.systemGray5))
                        }
                    if(eyeTrackingViewModel.eyeGazeActive){
                        if let pt = eyeTrackingViewModel.lookAtPoint, !eyeTrackingViewModel.isCalibrating {
                                            Circle()
                                                .fill(Color.red.opacity(0.5))
                                                .frame(width: 30, height: 30)
                                                .position(pt)
                                        }
                    }
                }
            }
        }
        .navigationTitle(Text(appViewModel.score != nil ? appViewModel.score!.name : "Page Turner"))
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
//            if(true)
            if(appViewModel.score != nil)
            {
                if(eyeTrackingViewModel.eyeGazeActive == false)
                {
                    ToolbarItem (placement: .navigationBarTrailing){
                        NavigationLink(destination: CalibrationPage()
                            .environmentObject(eyeTrackingViewModel)
                        ){
                            Image(systemName: "eye")
                        }
                    }
                }
                else {
                    ToolbarItem (placement: .navigationBarTrailing){
                        Button {
                            eyeTrackingViewModel.eyeGazeActive.toggle()
                        } label: {
                            Image(systemName: "eye.slash")
                        }
                    }
                }

                ToolbarItem (placement: .navigationBarTrailing){
                    Button {
                        showRight.toggle()
                    } label: {
                        Image(systemName: "book.pages")
                    }

                }
            }
        }
        .sheet(isPresented: $isShownSheet) {
            NewScorePage(isPresented: $isShownSheet).interactiveDismissDisabled(true)
        }
        .onChange(of: eyeTrackingViewModel.lookAtPoint){
            pt in
            if(!eyeTrackingViewModel.isCalibrating && pt != nil){
                print(pt)
                let w = Device.frameSize.width
                let h = Device.frameSize.height
                let leftP = CGPoint(x: w * 0.2, y: h * 0.2)
                let rightP = CGPoint(x: w * 0.8, y: h * 0.8)
                if((pt!.x < leftP.x + w * 0.1) && (pt!.y < leftP.y + h * 0.1) ){
                    if inRangeSince == nil {
                        inRangeSince = Date()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // 2초 뒤에도 여전히 범위 안이었다면 실행
                            if let start = inRangeSince,
                               Date().timeIntervalSince(start) >= 2 {
                                appViewModel.previousPage()
                                inRangeSince = nil  // 재실행 방지용 리셋
                            }
                        }
                    }
                }
                else if((pt!.x > rightP.x - w * 0.1) && (pt!.y > rightP.y - h * 0.1) ){
                    if inRangeSince == nil {
                        inRangeSince = Date()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // 2초 뒤에도 여전히 범위 안이었다면 실행
                            if let start = inRangeSince,
                               Date().timeIntervalSince(start) >= 2 {
                                appViewModel.nextPage()
                                inRangeSince = nil  // 재실행 방지용 리셋
                            }
                        }
                    }
                }
                else {
                    inRangeSince = nil
                }
            }
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
