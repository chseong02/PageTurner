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
    var url: URL
    var pageCount: Int
    var lastReadpage: Int
    init(name: String, composer: String, url: URL, pageCount: Int) {
        self.id = UUID()
        self.name = name
        self.composer = composer
        self.url = url
        self.isFavorite = false
        self.lastReadpage = 0
        self.pageCount = pageCount
    }
}
