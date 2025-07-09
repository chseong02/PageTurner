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
    @EnvironmentObject var appViewModel: ScoreViewModel
    var body: some View {
        VStack {
            if (appViewModel.score == nil) {
            //if (appViewModel.existNoPDf || !appViewModel.isOpened) {
                Text("아직 악보가 없네요!\n새 악보를 추가해주세요")
                    .font(.title)
                    .multilineTextAlignment(.center)
                //Button("악보 추가").buttonStyle(style: .bordered)
                Button{
                    isShownSheet = true
                }
                label: {
                    Text("악보 추가").font(.headline)
                }.buttonStyle(.borderedProminent)
            }
            else {
                PDFKitView(url: appViewModel.score!.url)
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
                    )
            }
        }
        .navigationTitle(Text("Page Turner"))
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing){
                Button {
                } label: {
                    Image(systemName: "book.pages")
                }

            }
        }
        .sheet(isPresented: $isShownSheet) {
            NewScorePage(isPresented: $isShownSheet).interactiveDismissDisabled(true)
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
