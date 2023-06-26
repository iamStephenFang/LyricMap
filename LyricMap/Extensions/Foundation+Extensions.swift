//
//  Foundation+Extensions.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/26.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
