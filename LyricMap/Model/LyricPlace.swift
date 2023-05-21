//
//  LyricPlace.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/17.
//

import MapKit
import Contacts

class LyricPlace: NSObject, MKAnnotation {
    // Lyric info of the place
    let lyricInfo: LyricInfo
    
    // locationName of the place
    let locationName: String
    
    // 2D Coordinate of the place
    let coordinate: CLLocationCoordinate2D
    
    init(
        lyricInfo: LyricInfo,
        locationName: String,
        coordinate: CLLocationCoordinate2D
    ) {
        self.lyricInfo = lyricInfo
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return lyricInfo.albumName
    }
    
    var title: String? {
        return lyricInfo.songName
    }
    
    var mapItem: MKMapItem? {
      let addressDict = [CNPostalAddressStreetKey: locationName]
      let placemark = MKPlacemark(
        coordinate: coordinate,
        addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
}
