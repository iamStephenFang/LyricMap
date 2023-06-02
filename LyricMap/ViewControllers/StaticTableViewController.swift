//
//  StaticTableViewController.swift
//  CostMator
//
//  Created by StephenFang on 2022/2/22.
//

import Foundation
import UIKit
import SnapKit


final class StaticTableViewCellItem {
    
    /// 设置需要显示的元素
    /// @param text 标题，传nil不显示
    /// @param attributedText 标题富文本，优先级高于text，传nil不显示
    /// @param detailText 详情，传nil不显示
    /// @param attributedDetailText 详情富文本，优先级高于detailText，传nil不显示
    /// @param image 标题前的图片，传nil不显示
    /// @param imageName 标题前的图片(SF Symbol)，替换image
    /// @param accessoryText 箭头侧的文本，传nil不显示
    /// @param accessoryView 箭头侧的View, 优先级高于accessoryText，传nil不显示
    /// @param accessoryType 箭头类型
    /// @param selectionStyle 选中样式
    /// @param selectionHandler 回调
    typealias SelectionHandler = (_ item: StaticTableViewCellItem) -> Void
    typealias AttributedTextConverter = ((String) -> NSAttributedString)
    typealias IconImageGenerator = ((String) -> UIImage)
    
    var attributedText: NSAttributedString?
    var attributedDetailText: NSAttributedString?
    var image: UIImage?
    var imageName: String?
    var accessoryView: UIView?
    var accessoryText: String?
    var selectionStyle: UITableViewCell.SelectionStyle?
    
    /// 定制 UITableViewCellAccessoryNone、UITableViewCellAccessoryDisclosureIndicator
    /// 当 accessoryView 为 nil 时，accessoryType 和 accessoryText 共同决定 cell 右侧的文本与箭头的显示
    var accessoryType: UITableViewCell.AccessoryType?
    
    var selectionHandler: SelectionHandler?
    
    static let attributedTitleConverter: ((String) -> NSAttributedString) = { title in
        return NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label,
            ]
        )
    }
    
    static let attributedDetailTitleConverter: ((String) -> NSAttributedString) = { detailTitle in
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 17;
        paragraphStyle.maximumLineHeight = 17;
        
        return NSAttributedString(string: detailTitle, attributes: [
            .font: UIFont.preferredFont(forTextStyle: .subheadline),
            .foregroundColor: UIColor.secondaryLabel,
            .paragraphStyle: paragraphStyle
        ])
    }
    
    static let iconImageGenerator: ((String) -> UIImage) = { imageName in
        let iconConfig = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title3))
        let systemImage = UIImage(systemName:imageName) ?? UIImage(systemName:"questionmark.square.dashed")
        return systemImage!.withTintColor(.tintColor).withConfiguration(iconConfig)
    }
    
    convenience init(
        title: String = "",
        attributedTitleConverter: AttributedTextConverter = StaticTableViewCellItem.attributedTitleConverter,
        detailTitle: String = "",
        attributedDetailTitleConverter: AttributedTextConverter = StaticTableViewCellItem.attributedDetailTitleConverter,
        image: UIImage? = nil,
        accessoryView: UIView? = nil,
        accessoryText: String? = nil,
        accessoryType: UITableViewCell.AccessoryType? = nil,
        selectionStyle: UITableViewCell.SelectionStyle? = nil,
        selectionHandler: SelectionHandler? = nil
    ) {
        let attributedText = attributedTitleConverter(title)
        let attributedDetailText = attributedDetailTitleConverter(detailTitle)
        self.init(
            attributedTitle: attributedText,
            attributedDetailTitle: attributedDetailText,
            image: image,
            accessoryView: accessoryView,
            accessoryText: accessoryText,
            accessoryType: accessoryType,
            selectionStyle: selectionStyle,
            selectionHandler: selectionHandler
        )
    }
    
    convenience init(
        title: String = "",
        iconImageGenerator: IconImageGenerator = StaticTableViewCellItem.iconImageGenerator,
        imageName: String!,
        accessoryView: UIView? = nil,
        accessoryText: String? = nil,
        accessoryType: UITableViewCell.AccessoryType? = nil,
        selectionStyle: UITableViewCell.SelectionStyle? = nil,
        selectionHandler: SelectionHandler? = nil
    ) {
        let iconImage = iconImageGenerator(imageName)
        self.init(
            title: title,
            image: iconImage,
            accessoryView: accessoryView,
            accessoryText: accessoryText,
            accessoryType: accessoryType,
            selectionStyle: selectionStyle,
            selectionHandler: selectionHandler
        )
    }
    
    init(
        attributedTitle: NSAttributedString,
        attributedDetailTitle: NSAttributedString,
        image: UIImage? = nil,
        accessoryView: UIView? = nil,
        accessoryText: String? = nil,
        accessoryType: UITableViewCell.AccessoryType? = nil,
        selectionStyle: UITableViewCell.SelectionStyle? = nil,
        selectionHandler: SelectionHandler? = nil
    ) {
        self.attributedText = attributedTitle
        self.attributedDetailText = attributedDetailTitle
        
        self.image = image
        self.accessoryView = accessoryView
        self.accessoryText = accessoryText
        self.accessoryType = accessoryType
        self.selectionStyle = selectionStyle
        self.selectionHandler = selectionHandler
    }
}


class StaticTableViewCell : UITableViewCell {
    
    public lazy var imageV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    } ()
    
    public lazy var textL: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    } ()
    
    public lazy var detailTextL: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    } ()
    
    public var accessoryV: UIView?
    public var item: StaticTableViewCellItem?
    
    private var detailTextTop: Constraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.secondarySystemFill
        selectedBackgroundView = view
        
        contentView.addSubview(imageV)
        imageV.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.top.equalTo(contentView).offset(12)
            make.left.equalTo(16)
        }
        
        contentView.addSubview(textL)
        textL.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(60)
            make.centerY.equalTo(imageV)
        }
        
        contentView.addSubview(detailTextL)
        detailTextL.snp.makeConstraints { make in
            make.left.equalTo(textL)
            detailTextTop = make.top.equalTo(textL.snp.bottom).offset(4).constraint
            make.right.lessThanOrEqualTo(-16)
            make.bottom.lessThanOrEqualTo(contentView).offset(-17)
        }
        
        self.detailTextTop.deactivate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        accessoryType = .none
        accessoryView = nil
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if (self.accessoryV != nil) {
            self.detailTextL.snp.makeConstraints { make in
                make.right.equalTo(accessoryV!.snp.left).offset(-10)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupItem(item:StaticTableViewCellItem) {
        self.item = item
        
        if (item.attributedText != nil && item.attributedText!.length > 0) {
            textL.attributedText = item.attributedText
            textL.isHidden = false
        } else {
            textL.isHidden = true
        }
        
        if (item.attributedDetailText != nil && item.attributedDetailText!.length > 0) {
            detailTextL.attributedText = item.attributedText
            detailTextL.isHidden = false
            detailTextTop.activate()
        } else {
            detailTextL.isHidden = true
            detailTextTop.deactivate()
        }
        
        if (item.image != nil) {
            imageV.image = item.image?.withRenderingMode(.alwaysOriginal)
            imageV.isHidden = false
            textL.snp.updateConstraints { make in
                make.left.equalTo(contentView).offset(60)
            }
        } else {
            textL.snp.updateConstraints { make in
                make.left.equalTo(contentView).offset(16)
            }
            imageV.isHidden = true
        }
        
        selectionStyle = item.selectionStyle ?? .default
        
        var accessoryView = item.accessoryView
        if (accessoryView == nil) {
            var container = AttributeContainer()
            container.foregroundColor = .secondaryLabel

            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString(item.accessoryText ?? "", attributes: container)
            configuration.imagePlacement = .trailing
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            if item.accessoryType == .disclosureIndicator {
                let iconConfig = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .footnote))
                configuration.image = UIImage(systemName:"chevron.forward")!.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal).withConfiguration(iconConfig)
            }
            
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.isUserInteractionEnabled = false
            button.sizeToFit()
            accessoryView = button
        }
        
        if (accessoryView!.superview != contentView) {
            accessoryView!.removeFromSuperview()
            if (accessoryV?.superview == contentView) {
                accessoryV?.removeFromSuperview()
            }
            contentView.addSubview(accessoryView!)
            accessoryView!.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalTo(imageV)
                make.left.greaterThanOrEqualTo(textL.snp.right).offset(20)
                make.width.equalTo(accessoryView!.bounds.size.width)
                make.height.equalTo(accessoryView!.bounds.size.height)
            }
            accessoryV = accessoryView
            setNeedsUpdateConstraints()
        }
    }
}

class StaticTableViewController : UITableViewController {
    public var cellItems: [[StaticTableViewCellItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = UIDefine.cellHeight
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.tableFooterView = UIView()
        tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(StaticTableViewCell.self))
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        if cellItems.count > 0 {
            tableView.reloadData()
        }
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    convenience init() {
        self.init(style: UITableView.Style.insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(StaticTableViewCell.self), for: indexPath) as! StaticTableViewCell
        let item = cellItems[indexPath.section][indexPath.item]
        cell.setupItem(item: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = cellItems[indexPath.section][indexPath.item]
        if (item.selectionHandler != nil) {
            item.selectionHandler!(item)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.tableFooterView!.frame.size.height > 0 && section == cellItems.count - 1 {
            return tableView.sectionHeaderHeight
        } else {
            return tableView.sectionFooterHeight
        }
    }
}

