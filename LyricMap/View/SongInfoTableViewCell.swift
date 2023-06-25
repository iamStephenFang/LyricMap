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

    static let iconConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15))
    
    func configure(with info: LyricInfo) {
        accessoryType = .detailButton
        var content = defaultContentConfiguration()
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "pin", withConfiguration: SongInfoTableViewCell.iconConfig)?.withTintColor(.tintColor)
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSAttributedString(string: info.locationName))
        content.attributedText = fullString
        
        content.secondaryText = info.songInfo.songName + "·" + info.songInfo.artistName
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
