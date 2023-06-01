//
//  SectionList.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/22.
//

import Foundation

struct SectionItem: Decodable, Hashable {
    let id: Int
    let tagline: String
    let name: String
    let subheading: String
    let imageUrl: String
}
