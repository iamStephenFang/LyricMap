//
//  FeaturedCell.swift
//  TapStore
//
//  Created by Paul Hudson on 01/10/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class FeaturedCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier: String = "FeaturedCell"

    let tagline = UILabel()
    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let separator = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .quaternaryLabel

        tagline.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagline.textColor = .systemBlue

        name.font = UIFont.preferredFont(forTextStyle: .title2)
        name.textColor = .label

        subtitle.font = UIFont.preferredFont(forTextStyle: .title3)
        subtitle.textColor = .secondaryLabel

        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        let stackView = UIStackView(arrangedSubviews: [separator, tagline, name, subtitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        stackView.setCustomSpacing(10, after: separator)
        stackView.setCustomSpacing(10, after: subtitle)
    }

    func configure(with item: SectionItem) {
        tagline.text = item.tagline.uppercased()
        name.text = item.name
        subtitle.text = item.subheading
        imageView.image = UIImage(named: item.image)
    }

    required init?(coder: NSCoder) {
        fatalError("Not happening")
    }
}
