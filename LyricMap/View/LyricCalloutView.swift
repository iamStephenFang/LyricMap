//
//  LyricCalloutView.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/23.
//

import UIKit
import MapKit


class LyricCalloutView: UIView {
    
    fileprivate let songLabel = UILabel()
    fileprivate let artistLabel = UILabel()
    fileprivate let albumButton = UIButton()
    fileprivate let lyricLabel = UILabel()
    
    fileprivate let bookmarkButton = ZoomButton()
    fileprivate let visitedButton = ZoomButton()
    fileprivate let shareButton = ZoomButton()
    fileprivate let navigateButton = ZoomButton()
    
    fileprivate let realityButton = ZoomButton()
    fileprivate let moreButton = ZoomButton()
    
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
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        bookmarkButton.backgroundColor = LyricInfoManager.shared().favoritedList.contains(lyricInfo) ? UIColor.tintColor : UIColor.systemFill
        bookmarkButton.layer.cornerRadius = 8
        bookmarkButton.addTarget(self, action: #selector(didClickBookmark), for: .touchUpInside)
        addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(albumButton.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.width.equalTo(70)
            make.left.equalToSuperview()
        }
        
        visitedButton.setImage(UIImage(systemName: "pin.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        visitedButton.backgroundColor = LyricInfoManager.shared().visitedList.contains(lyricInfo) ? UIColor.tintColor : UIColor.systemFill
        visitedButton.layer.cornerRadius = 8
        visitedButton.addTarget(self, action: #selector(didClickVisit), for: .touchUpInside)
        addSubview(visitedButton)
        visitedButton.snp.makeConstraints { make in
            make.top.equalTo(albumButton.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.width.equalTo(70)
            make.left.equalTo(bookmarkButton.snp.right).offset(10)
        }
        
        navigateButton.setImage(UIImage(systemName: "location.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        navigateButton.backgroundColor = .systemFill
        navigateButton.layer.cornerRadius = 8
        navigateButton.addTarget(self, action: #selector(didClickNavigate), for: .touchUpInside)
        addSubview(navigateButton)
        navigateButton.snp.makeConstraints { make in
            make.top.equalTo(albumButton.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.width.equalTo(70)
            make.left.equalTo(visitedButton.snp.right).offset(10)
        }
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        shareButton.backgroundColor = .systemFill
        shareButton.layer.cornerRadius = 8
        shareButton.addTarget(self, action: #selector(didClickShare), for: .touchUpInside)
        addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(albumButton.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.width.equalTo(70)
            make.left.equalTo(navigateButton.snp.right).offset(10)
            make.right.equalToSuperview()
        }
        
        moreButton.setImage(UIImage(systemName: "ellipsis")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        moreButton.backgroundColor = .systemFill
        moreButton.layer.cornerRadius = 8
        let reportAction =
            UIAction(title: NSLocalizedString("map_report_title", comment: ""),
                     image: UIImage(systemName: "questionmark")?.withTintColor(UIColor.tintColor)) { action in
            }
        moreButton.menu = UIMenu(title: "", children: [reportAction])
        moreButton.showsMenuAsPrimaryAction = true
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        realityButton.setImage(UIImage(systemName: "cube.transparent.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        realityButton.setTitle("AR Lyric", for: .normal)
        realityButton.backgroundColor = UIColor(hexString: "#C8E7A5")
        realityButton.layer.cornerRadius = 8
        realityButton.addTarget(self, action: #selector(didClickReality), for: .touchUpInside)
        addSubview(realityButton)
        realityButton.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.left.equalToSuperview()
            make.right.equalTo(moreButton.snp.left).offset(-10)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: Actions
    
    @objc private func didClickNavigate() {
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
        ]
        lyricInfo.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
    @objc private func didClickVisit() {
        if LyricInfoManager.shared().visitedList.contains(lyricInfo) {
            guard let index = LyricInfoManager.shared().visitedList.firstIndex(of: lyricInfo) else {
                return
            }
            LyricInfoManager.shared().visitedList.remove(at: index)
        } else {
            LyricInfoManager.shared().visitedList.append(lyricInfo)
        }
        visitedButton.backgroundColor = LyricInfoManager.shared().visitedList.contains(lyricInfo) ? UIColor.tintColor : UIColor.systemFill
    }
    
    @objc private func didClickShare() {
        let activityViewController = UIActivityViewController(activityItems: [lyricInfo.songInfo.songName, URL(string: "https://maps.apple.com?ll=\(lyricInfo.coordinate.latitude),\(lyricInfo.coordinate.longitude)")!], applicationActivities: nil)
        self.window?.rootViewController?.present(activityViewController, animated: true)
    }
    
    @objc private func didClickBookmark() {
        if LyricInfoManager.shared().favoritedList.contains(lyricInfo) {
            guard let index = LyricInfoManager.shared().favoritedList.firstIndex(of: lyricInfo) else {
                return
            }
            LyricInfoManager.shared().favoritedList.remove(at: index)
        } else {
            LyricInfoManager.shared().favoritedList.append(lyricInfo)
        }
        bookmarkButton.backgroundColor = LyricInfoManager.shared().favoritedList.contains(lyricInfo) ? UIColor.tintColor : UIColor.systemFill
    }
    
    @objc private func didClickReality() {
        let containerViewController = ARLyricViewController(lyricInfo)
        containerViewController.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(containerViewController, animated: true)
    }
}

