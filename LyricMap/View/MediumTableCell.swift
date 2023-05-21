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

    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    let playButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)

        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .label

        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel

        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true

        playButton.setImage(UIImage(systemName: "play"), for: .normal)

        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        playButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let innerStackView = UIStackView(arrangedSubviews: [name, subtitle])
        innerStackView.axis = .vertical

        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView, playButton])
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

    func configure(with item: SectionItem) {
        name.text = item.name
        subtitle.text = item.subheading
        imageView.image = UIImage(named: item.image)?.imageWithSize(size: CGSize(width:62, height: 62))
    }

    required init?(coder: NSCoder) {
        fatalError("Just… no")
    }
}
