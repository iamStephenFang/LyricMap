//
//  WelcomeTableViewCell.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        textLabel?.textColor = .label
        textLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        
        detailTextLabel?.textColor = .secondaryLabel
        detailTextLabel?.font = .systemFont(ofSize: 15)
        detailTextLabel?.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setupInfo(_ info: FeatureInfo) {
        textLabel?.text = info.title
        detailTextLabel?.text = info.subtitle
        imageView?.image = info.icon
    }
}
