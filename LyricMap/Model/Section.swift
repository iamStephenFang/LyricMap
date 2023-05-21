//
//  Section.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import Foundation

struct Section: Decodable, Hashable {
    let id: Int
    let type: String
    let title: String
    let subtitle: String
    let items: [SectionItem]
}
