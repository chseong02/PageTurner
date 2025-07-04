//
//  Score.swift
//  PageTurner
//
//  Created by chseong on 7/3/25.
//

import Foundation
import SwiftData

@Model
final class Score {
    @Attribute(.unique) var id: UUID
    var name: String
    var composer: String
    var isFavorite: Bool
    //TODO: 악보 경로 같은 정보 타입 나중에 확정
    var path: String
    init(name: String, composer: String, path: String) {
        self.id = UUID()
        self.name = name
        self.composer = composer
        self.path = path
        self.isFavorite = false
    }
}
