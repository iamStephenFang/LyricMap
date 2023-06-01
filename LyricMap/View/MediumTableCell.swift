//
//  MediumTableCell.swift
//  TapStore
//
//  Created by Paul Hudson on 01/10/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class MediumTableCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier: String = "MediumTableCell"
    static let iconConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 25, weight: .light))
    
    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    let playButton = UIButton(type: .custom)
    let infoButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)

        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .label

        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel

        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true

        playButton.setImage(UIImage(systemName: "play.circle")?.withConfiguration(MediumTableCell.iconConfig), for: .normal)
        playButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        infoButton.setImage(UIImage(systemName: "info.circle")?.withConfiguration(MediumTableCell.iconConfig), for: .normal)
        infoButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let innerStackView = UIStackView(arrangedSubviews: [name, subtitle])
        innerStackView.axis = .vertical

        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView, infoButton, playButton])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        contentView.addSubview(outerStackView)

        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: SectionItem) {
        name.text = item.name
        subtitle.text = item.subheading
        imageView.image = UIImage(named: item.image)?.imageWithSize(size: CGSize(width:62, height: 62))
    }
}
