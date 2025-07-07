//
//  ScorePageLeftSideView.swift
//  PageTurner
//
//  Created by chseong on 7/4/25.
//

import SwiftUI
import SwiftData

struct ScorePageLeftSideView: View {
    var body: some View {
        List {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                  TextField("", text: .constant(""))
                    .foregroundColor(Color.gray)
                }
                .padding(
                    .vertical, 8
                )
//                    .overlay(
//                      RoundedRectangle(cornerRadius: 8)
//                        .stroke(lineWidth: 1.5)
//                        .foregroundColor(Color.black)
//                    )
//                    HStack {
//                        Image(systemName: "magniﬁcationglass")
//                        TextField()
//                    }
            }
            Section (
                header:Text("즐겨찾기"),
                content: {
                    SideBarScoreItemView()
                    SideBarScoreItemView()
                    SideBarScoreItemView()
                    SideBarScoreItemView()
                }

            )
            Section (header:Text("악보"),content: {
                SideBarScoreItemView()
                SideBarScoreItemView()
                SideBarScoreItemView()
            })
        }.listStyle(.insetGrouped)
        .navigationTitle(Text("악보"))
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing){
                Button {
                } label: {
                    Image(systemName: "plus")
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
