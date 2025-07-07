//
//  ContentView.swift
//  PageTurner
//
//  Created by chseong on 7/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var appViewModel: AppViewModel
    
    init(modelContext: ModelContext) {
        _appViewModel = StateObject(wrappedValue: AppViewModel(modelContext: modelContext))
    }
    var body: some View {
        NavigationSplitView {
            ScorePageLeftSideView()
        } detail: {
            ScorePageMainView()
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
