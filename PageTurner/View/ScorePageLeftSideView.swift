//
//  ScorePageLeftSideView.swift
//  PageTurner
//
//  Created by chseong on 7/4/25.
//

import SwiftUI
import SwiftData

struct ScorePageLeftSideView: View {
    @StateObject private var scoreListViewModel: ScoreListViewModel = ScoreListViewModel()
    @Environment(\.modelContext) var modelContext: ModelContext
    @State var isShownSheet: Bool = false
    var body: some View {
        List {
            if (!scoreListViewModel.scores.isEmpty) {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                        TextField("", text: $scoreListViewModel.searchTerm)
                        .foregroundColor(Color.gray)
                    }
                    .padding(
                        .vertical, 8
                    )
                }
                if(!scoreListViewModel.favoriteScores.isEmpty) {
                    Section (
                        header:Text("즐겨찾기"),
                        content: {
                            ForEach(scoreListViewModel.favoriteScores, id: \.self) { score in
                                SideBarScoreItemView(score: score)
                            }
                        }
                    )
                }
                Section (header:Text("악보"),content: {
                    ForEach(scoreListViewModel.nonFavoriteScores, id: \.self) { score in
                        SideBarScoreItemView(score: score)
                    }
                })
            }
            else {
                HStack {
                    Spacer()
                    Text("아직 악보가 없어요...")
                        .font(.caption)
                    Spacer()
                }.padding(.vertical, 32)
            }
        }.listStyle(.insetGrouped)
        .navigationTitle(Text("악보"))
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing){
                Button {
                    isShownSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }.onAppear {
            scoreListViewModel.searchTerm = ""
            scoreListViewModel.initModelContext(modelContext: modelContext)
            scoreListViewModel.getScores()
        }.sheet(isPresented: $isShownSheet) {
            NewScorePage(isPresented: $isShownSheet).interactiveDismissDisabled(true)
        }.environmentObject(scoreListViewModel)
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
