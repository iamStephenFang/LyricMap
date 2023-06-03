//
//  LyricCollection.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import Foundation

enum CollectionType {
    case favorited
    case visited
    case custom
}

struct LyricCollection {
    let id: Int
    let type: CollectionType
    let title: String
    let subtitle: String
    let imageName: String
    let infos: [LyricInfo]
}
