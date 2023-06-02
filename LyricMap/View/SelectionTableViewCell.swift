//
//  SelectionTableViewCell.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit


final class SelectionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "SelectionTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .secondarySystemFill
        selectedBackgroundView = view
        
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
