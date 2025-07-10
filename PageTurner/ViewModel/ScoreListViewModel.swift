//
//  ScoreListViewModel.swift
//  PageTurner
//
//  Created by chseong on 7/9/25.
//

import SwiftUI
import SwiftData
import PDFKit


class ScoreListViewModel: ObservableObject {
    @Published var scores: [Score] = []
    @Published var searchTerm: String = ""
    private var modelContext: ModelContext?
    var context: ModelContext {
        return modelContext!
    }
    var favoriteScores: [Score] {
        get {
            if(searchTerm == ""){
                return scores.filter { $0.isFavorite }
            }
            else {
                return searchResults.filter { $0.isFavorite }
            }
        }
    }
    var nonFavoriteScores: [Score] {
        get {
            if(searchTerm == ""){
                return scores.filter { $0.isFavorite == false }
            }
            else {
                return searchResults.filter { $0.isFavorite == false }
            }
        }
    }
    
    var searchResults: [Score] {
        get {
            scores.filter {
                ($0.name+"\n"+$0.composer).lowercased().contains(searchTerm.lowercased())
            }
        }
    }
    func initModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getScores() {
        do {
            let descriptor = FetchDescriptor<Score>()
            self.scores = try context.fetch(descriptor)
        } catch {
        }
    }
    func changeSearchTerm(term: String) {
        searchTerm = term
    }
    func update() {
        getScores()
    }
}
