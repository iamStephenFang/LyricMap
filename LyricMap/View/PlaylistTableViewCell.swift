//
//  PlaylistTableViewCell.swift
//  TapStore
//
//  Created by Paul Hudson on 01/10/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier: String = "PlaylistTableViewCell"

    let rankLabel = UILabel()
    let name = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        rankLabel.font = UIFont.preferredFont(forTextStyle: .body)
        rankLabel.textColor = .tintColor
        
        name.font = UIFont.preferredFont(forTextStyle: .title3)
        name.textColor = .label

        let stackView = UIStackView(arrangedSubviews: [rankLabel, name])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 20
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with item: SectionItem) {
        name.text = item.name
        rankLabel.text = item.tagline
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
