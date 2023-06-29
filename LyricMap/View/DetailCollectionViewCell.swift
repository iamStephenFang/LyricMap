//
//  DetailCollectionViewCell.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/1.
//

import UIKit
import MapKit


class DetailCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "DetailCollectionViewCell"
    
    fileprivate let songLabel = UILabel()
    fileprivate let artistLabel = UILabel()
    fileprivate let albumButton = UIButton()
    fileprivate let lyricLabel = UILabel()
    fileprivate let distanceLabel = UILabel()
    
    fileprivate let bookmarkButton = ZoomButton()
    fileprivate let visitedButton = ZoomButton()
    fileprivate let shareButton = ZoomButton()
    fileprivate let navigateButton = ZoomButton()
    
    fileprivate let realityButton = ZoomButton()
    fileprivate let moreButton = ZoomButton()
    
    fileprivate var lyricInfo: LyricInfo!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = UIDefine.sheetCornerRadius
        
        let itemWidth = (contentView.frame.width - 16 * 2 - 10 * 3) / 4
        
        distanceLabel.textColor = .tintColor
        distanceLabel.font = .preferredFont(forTextStyle: .callout)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.textAlignment = .center
        contentView.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        albumButton.layer.cornerRadius = 5
        albumButton.contentMode = .scaleAspectFill
        albumButton.clipsToBounds = true
        contentView.addSubview(albumButton)
        albumButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }

        songLabel.textColor = .label
        songLabel.font = .preferredFont(forTextStyle: .title2)
        contentView.addSubview(songLabel)
        songLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalTo(albumButton.snp.right).offset(16)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-16)
        }
        
        artistLabel.textColor = .secondaryLabel
        artistLabel.font = .preferredFont(forTextStyle: .title3)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(songLabel.snp.bottom).offset(8)
            make.left.equalTo(albumButton.snp.right).offset(16)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-16)
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
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(-16)
        }
        
        realityButton.setImage(UIImage(systemName: "cube.transparent.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        realityButton.setTitle("AR Lyric", for: .normal)
        realityButton.backgroundColor = UIColor(hexString: "#C8E7A5")
        realityButton.layer.cornerRadius = 8
        realityButton.addTarget(self, action: #selector(didClickReality), for: .touchUpInside)
        contentView.addSubview(realityButton)
        realityButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.right.equalTo(moreButton.snp.left).offset(-10)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        bookmarkButton.layer.cornerRadius = 8
        bookmarkButton.addTarget(self, action: #selector(didClickBookmark), for: .touchUpInside)
        contentView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.bottom.equalTo(realityButton.snp.top).offset(-16)
            make.height.equalTo(50)
            make.width.equalTo(itemWidth)
            make.left.equalToSuperview().offset(16)
        }
        
        visitedButton.setImage(UIImage(systemName: "pin.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        visitedButton.layer.cornerRadius = 8
        visitedButton.addTarget(self, action: #selector(didClickVisit), for: .touchUpInside)
        contentView.addSubview(visitedButton)
        visitedButton.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.top)
            make.height.equalTo(50)
            make.width.equalTo(itemWidth)
            make.left.equalTo(bookmarkButton.snp.right).offset(10)
        }
        
        navigateButton.setImage(UIImage(systemName: "location.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        navigateButton.backgroundColor = .systemFill
        navigateButton.layer.cornerRadius = 8
        navigateButton.addTarget(self, action: #selector(didClickNavigate), for: .touchUpInside)
        contentView.addSubview(navigateButton)
        navigateButton.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.top)
            make.height.equalTo(50)
            make.width.equalTo(itemWidth)
            make.left.equalTo(visitedButton.snp.right).offset(10)
        }
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        shareButton.backgroundColor = .systemFill
        shareButton.layer.cornerRadius = 8
        shareButton.addTarget(self, action: #selector(didClickShare), for: .touchUpInside)
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.top)
            make.height.equalTo(50)
            make.width.equalTo(itemWidth)
            make.left.equalTo(navigateButton.snp.right).offset(10)
            make.right.equalToSuperview().offset(-16)
        }
        
        lyricLabel.textColor = .tertiaryLabel
        lyricLabel.font = .preferredFont(forTextStyle: .body)
        lyricLabel.translatesAutoresizingMaskIntoConstraints = false
        lyricLabel.numberOfLines = 0
        contentView.addSubview(lyricLabel)
        lyricLabel.snp.makeConstraints { make in
            make.top.equalTo(albumButton.snp.bottom).offset(16)
            make.bottom.equalTo(bookmarkButton.snp.top).offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with info: LyricInfo) {
        self.lyricInfo = info
        albumButton.sd_setImage(with: URL(string: info.songInfo.albumImageUrl), for: .normal, placeholderImage: UIImage(named: "PlaceHolder"))
        songLabel.text = info.songInfo.songName
        artistLabel.text = info.songInfo.artistName
        lyricLabel.text = info.content
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 12)))?.withTintColor(.tintColor)
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        let distance = (info.coordinate.distance(from: CLLocationManager().location!.coordinate) / 1000.0).rounded(toPlaces: 2)
        fullString.append(NSAttributedString(string: " \(distance)km"))
        distanceLabel.attributedText = fullString
        
        visitedButton.backgroundColor = LyricInfoManager.shared().visitedList.contains(lyricInfo) ? UIColor.tintColor : UIColor.systemFill
        bookmarkButton.backgroundColor = LyricInfoManager.shared().favoritedList.contains(lyricInfo) ? UIColor.tintColor : UIColor.systemFill
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


