//
//  SongInfoTableViewCell.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit
import SDWebImage

class SongInfoTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "SongInfoTableViewCell"

    func configure(with info: LyricInfo) {
        accessoryType = .detailButton
        var content = defaultContentConfiguration()
        content.text = info.songInfo.songName + "·" + info.songInfo.artistName
        content.secondaryText = info.locationName
        SDWebImageManager.shared.loadImage(
            with: URL(string: info.songInfo.albumImageUrl),
            options: .continueInBackground,
            progress: nil,
            completed: { (image, data, error, cacheType, finished, url) in
                content.image = image
                self.contentConfiguration = content
            }
        )
    }
}
