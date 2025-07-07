//
//  NewScoreViewModel.swift
//  PageTurner
//
//  Created by chseong on 7/7/25.
//
import SwiftUI
import SwiftData

class NewScoreViewModel: ObservableObject {
    @Published var scoreName: String = ""
    @Published var composerName: String = ""
    @Published var scorePath: URL? = nil
    private var modelContext: ModelContext?
    private var context: ModelContext {
        get {
            return modelContext!
        }
    }
    
    func initModelContext(context: ModelContext){
        modelContext = context
    }
    
    func setScorePath(urls: Array<URL>) {
        scorePath = urls.first
    }
    
    func complete() {
        if(scorePath != nil){
            let newScore = Score(name: scoreName, composer: composerName, url: scorePath!)
            context.insert(newScore)
        }
        //TODO: else 처리
    }
}
