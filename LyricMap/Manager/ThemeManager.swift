//
//  ThemeManager.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit

enum Theme: String {
    case system
    case light
    case dark
}

struct ThemeManager {
    func currentTheme() -> Theme {
        if let rawValue = UserDefaults.standard.string(forKey: .appColorTheme) {
            return Theme(rawValue: rawValue)!
        } else {
            updateTheme(.system)
            return .system
        }
    }
    
    func updateTheme(_ theme: Theme) {
        switch theme {
        case .system:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .unspecified
        case .light:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
        case .dark:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
        }
        UserDefaults.standard.set(theme.rawValue, forKey: .appColorTheme)
    }
}
