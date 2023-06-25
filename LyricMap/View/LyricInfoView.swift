//
//  LyricInfoView.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/25.
//

import UIKit

class LyricInfoView: UIView {
    
    fileprivate let songLabel = UILabel()
    fileprivate let artistLabel = UILabel()
    fileprivate let albumButton = UIButton()
    fileprivate let lyricLabel = UILabel()
    
    fileprivate let lyricInfo: LyricInfo
    
    init(lyricInfo: LyricInfo) {
        self.lyricInfo = lyricInfo
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        albumButton.layer.cornerRadius = 5
        albumButton.contentMode = .scaleAspectFill
        albumButton.clipsToBounds = true
        addSubview(albumButton)
        albumButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        albumButton.sd_setImage(with: URL(string: lyricInfo.songInfo.albumImageUrl), for: .normal, placeholderImage: UIImage(named: "PlaceHolder"))
        
        songLabel.text = lyricInfo.songInfo.songName
        songLabel.textColor = .label
        songLabel.font = .preferredFont(forTextStyle: .title2)
        addSubview(songLabel)
        songLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(albumButton.snp.right).offset(16)
            make.height.equalTo(25)
            make.right.equalToSuperview()
        }
        
        artistLabel.text = lyricInfo.songInfo.artistName
        artistLabel.textColor = .secondaryLabel
        artistLabel.font = .preferredFont(forTextStyle: .title3)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(artistLabel)
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(songLabel.snp.bottom).offset(8)
            make.left.equalTo(albumButton.snp.right).offset(16)
            make.height.equalTo(20)
            make.right.equalToSuperview()
        }
        
        lyricLabel.text = lyricInfo.content
        lyricLabel.textColor = .tertiaryLabel
        lyricLabel.font = .preferredFont(forTextStyle: .body)
        lyricLabel.translatesAutoresizingMaskIntoConstraints = false
        lyricLabel.numberOfLines = 2
        addSubview(lyricLabel)
        lyricLabel.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom).offset(8)
            make.left.equalTo(albumButton.snp.right).offset(16)
            make.height.equalTo(40)
            make.right.equalToSuperview()
        }
    }
}


