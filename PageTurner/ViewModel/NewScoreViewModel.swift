//
//  NewScoreViewModel.swift
//  PageTurner
//
//  Created by chseong on 7/7/25.
//
import SwiftUI

class NewScoreViewModel: ObservableObject {
    @Published var scoreName: String = ""
    @Published var composerName: String = ""
    
    func complete() {
        
    }
}
