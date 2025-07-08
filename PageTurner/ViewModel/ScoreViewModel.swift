//
//  ScoreViewModel.swift
//  PageTurner
//
//  Created by chseong on 7/3/25.
//
import Foundation
import SwiftData

class ScoreViewModel: ObservableObject {
    private let modelContext: ModelContext
    @Published var existNoPDf: Bool
    @Published var isOpened: Bool
    @Published var score: Score?
    @Published var page: Int
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        //TODO context 쿼리로 값 가져오기?
        do {
            let descriptor = FetchDescriptor<LastReadScore>()
            let lastReadScores: [LastReadScore] = try modelContext.fetch(descriptor)
            if(lastReadScores.isEmpty){
                existNoPDf = true
                isOpened = false
                score = nil
                page = 0
            }
            else {
                let lastReadScore: LastReadScore = lastReadScores[0]
                existNoPDf = false
                isOpened = true
                let targetID = lastReadScore.id
                let descriptor = FetchDescriptor<Score>(predicate: #Predicate<Score> {$0.id == targetID})
                let foundedScore: Score? = (try modelContext.fetch(descriptor)).first
                if(foundedScore != nil){
                    score = foundedScore
                    page = foundedScore!.lastReadpage
                }
                else {
                    page = 0
                    score = nil
                }
            }
        } catch {
            existNoPDf = true
            isOpened = false
            score = nil
            page = 0
        }
    }
    
    func refresh() {
        
    }
    
    func openScore(uuid: UUID) {
        do {
            let descriptor = FetchDescriptor<Score>(predicate: #Predicate<Score> {$0.id == uuid})
            let foundedScore: Score? = (try modelContext.fetch(descriptor)).first
            if(foundedScore != nil){
                score = foundedScore
                page = score!.lastReadpage
                existNoPDf = false
                isOpened = true
            }
            let descriptor2 = FetchDescriptor<LastReadScore>()
            let lastReadScores: [LastReadScore] = try modelContext.fetch(descriptor2)
            if (lastReadScores.isEmpty) {
                let lastReadScore = LastReadScore(id: uuid)
                modelContext.insert(lastReadScore)
            }
            else {
                lastReadScores[0].id = uuid
            }
        }
        catch {
            
        }
    }
}
