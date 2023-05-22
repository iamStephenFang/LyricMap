//
//  LyricCollection.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import Foundation

struct LyricCollection: Decodable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let imageName: String
    let infos: [LyricInfo]
}
