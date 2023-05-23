//
//  LyricPlace.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/17.
//

import MapKit
import Contacts

class LyricInfo: NSObject, MKAnnotation {
    // song info for this lyric
    let songInfo: SongInfo
    
    // lyric content
    let content: String
    
    // position of the song
    let position: TimeInterval = 0
    
    // locationName of the place
    let locationName: String
    
    // 2D Coordinate of the place
    let coordinate: CLLocationCoordinate2D
    
    init(
        songInfo: SongInfo,
        content: String,
        locationName: String,
        coordinate: CLLocationCoordinate2D
    ) {
        self.songInfo = songInfo
        self.locationName = locationName
        self.coordinate = coordinate
        self.content = content
        
        super.init()
    }
    
    var mapItem: MKMapItem? {
        let addressDict = [CNPostalAddressStreetKey: locationName]
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = songInfo.songName
        return mapItem
    }
}
