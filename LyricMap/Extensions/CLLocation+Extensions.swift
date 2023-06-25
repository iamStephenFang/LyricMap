//
//  CLLocation+Extensions.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/25.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}

extension CLLocationCoordinate2D {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    /// - Returns: the distance in meters
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
            let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
            let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
            return from.distance(from: to)
        }
}
