//
//  LyricCollectionViewCell.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/22.
//

import UIKit

class LyricCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "LyricCollectionViewCell"

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.textColor = .label
        
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        subtitleLabel.textColor = .secondaryLabel

        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        stackView.setCustomSpacing(10, after: subtitleLabel)
    }
    
    func configure(with collection: LyricCollection) {
        titleLabel.text = collection.title
        subtitleLabel.text = collection.subtitle
        imageView.image = UIImage(named: collection.imageName)?.imageWithRoundedCorners(radius: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
