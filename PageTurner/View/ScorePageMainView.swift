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
    
    var body: some View {
        VStack {
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
