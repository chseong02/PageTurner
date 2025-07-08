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
    @Published var uuid: UUID? = nil
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
        if(urls.isEmpty){
            return
        }
        let pickedURL = urls[0]
        
        do {
            // 2) 보안 스코프 시작
            guard pickedURL.startAccessingSecurityScopedResource() else {
                throw NSError(domain: "ImportError", code: -1, userInfo: [NSLocalizedDescriptionKey: "보안 스코프 접근 실패"])
            }
            defer { pickedURL.stopAccessingSecurityScopedResource() }
            
            // 3) 앱 Documents 디렉토리 경로 계산
            let docsDir = FileManager.default.urls(
                for: .documentDirectory,
                   in: .userDomainMask
            ).first!
            let destURL = docsDir.appendingPathComponent(pickedURL.lastPathComponent)
            
            // 4) 기존 파일이 있으면 삭제
            if FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.removeItem(at: destURL)
            }
            
            // 5) 복사
            try FileManager.default.copyItem(at: pickedURL, to: destURL)
            scorePath = destURL
        }
        catch {
            print("완전 에러야!!")
        }
    }
    
    func complete() {
        if(scorePath != nil){
            let newScore = Score(name: scoreName, composer: composerName, url: scorePath!)
            context.insert(newScore)
            uuid = newScore.id
        }
        //TODO: else 처리
    }
}
