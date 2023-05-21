//
//  LyricInfo.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/17.
//

import Foundation

struct LyricInfo {
    // Name of the song
    let songName: String
    
    // Name of the song's album
    let albumName: String
    
    // Link of the album's cover
    let albumImageUrl: String
    
    // Name of the song's artist
    let artistName: String
    
    // Highlighted lyrics of the song
    let highlightedLyrics: [String]
    
    // Highlighted position of the song
    let highlightedPosition: TimeInterval
}
