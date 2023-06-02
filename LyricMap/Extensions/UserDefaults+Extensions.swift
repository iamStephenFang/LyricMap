//
//  UserDefaults+Extensions.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import Foundation

extension UserDefaults {
    
    enum Key: String {
        case isRegisteredUser
        case appColorTheme
    }
    
    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func bool(forKey key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: Key) {
        set(integer, forKey: key.rawValue)
    }
    
    func set(_ string: String, forKey key: Key) {
        set(string, forKey: key.rawValue)
    }
    
    func set(_ bool: Bool?, forKey key: Key) {
        set(bool, forKey: key.rawValue)
    }
    
    func set(_ object: Any?, forKey key: Key) {
        set(object, forKey: key.rawValue)
    }
}
