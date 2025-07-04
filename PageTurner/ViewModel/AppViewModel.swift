//
//  AppViewModel.swift
//  PageTurner
//
//  Created by chseong on 7/3/25.
//
import Foundation
import SwiftData

class AppViewModel: ObservableObject {
    private let modelContext: ModelContext
    @Published var isFirst: Bool
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        //TODO context 쿼리로 값 가져오기?
        self.isFirst = true
    }
}
