//
//  LastReadScore.swift
//  PageTurner
//
//  Created by chseong on 7/7/25.
//

import Foundation
import SwiftData

@Model
final class LastReadScore {
    var id: UUID

    init(id: UUID) {
        self.id = id
    }
}
