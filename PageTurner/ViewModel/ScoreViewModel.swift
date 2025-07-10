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
    var pageCount: Int
    
    init(modelContext: ModelContext) {
        existNoPDf = true
        isOpened = false
        score = nil
        page = 0
        pageCount = 0
        
        self.modelContext = modelContext
        //TODO context 쿼리로 값 가져오기?
        do {
            let descriptor = FetchDescriptor<LastReadScore>()
            let lastReadScores: [LastReadScore] = try modelContext.fetch(descriptor)
            if(lastReadScores.isEmpty){
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
                    pageCount = foundedScore!.pageCount
                }
                else {
                }
            }
        } catch {
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
                pageCount = score!.pageCount
            }
            let descriptor2 = FetchDescriptor<LastReadScore>()
            let lastReadScores: [LastReadScore] = try modelContext.fetch(descriptor2)
            print(lastReadScores)
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
    
    func nextPage() {
        print(page)
        print(pageCount)
        if(pageCount>page) {
            page+=1
            score!.lastReadpage = page
        }
    }
    
    func previousPage() {
        if(page>0) {
            page-=1
            score!.lastReadpage = page
        }
    }
    func goToPage(_ page: Int) {
        self.page = page
        score!.lastReadpage = page
    }
}
