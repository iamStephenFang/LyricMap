//
//  Bundle+Extensions.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import Foundation

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
