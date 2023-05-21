//
//  WelcomeViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
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

class WelcomeView: UIView {
    
    private var verticalPadding : CGFloat = 65.0
    private var labelHeight : CGFloat = 40.0
    private var cellHeight : CGFloat = 90.0
    
    fileprivate let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
    
    fileprivate let featureInfos = [
        FeatureInfo(title: NSLocalizedString("welcome_map_title", comment: ""),
                      subtitle: NSLocalizedString("welcome_map_subtitle", comment: ""),
                      icon: (UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)))!),
        FeatureInfo(title: NSLocalizedString("welcome_collection_title", comment: ""),
                      subtitle: NSLocalizedString("welcome_collection_subtitle", comment: ""),
                      icon: (UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)))!),
        FeatureInfo(title: NSLocalizedString("welcome_bookmark_title", comment: ""),
                      subtitle: NSLocalizedString("welcome_bookmark_subtitle", comment: ""),
                    icon: (UIImage(systemName: "bookmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)))!),
        FeatureInfo(title: NSLocalizedString("welcome_privacy_title", comment: ""),
                      subtitle: NSLocalizedString("welcome_privacy_subtitle", comment: ""),
                      icon: (UIImage(systemName: "checkmark.shield", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)))!),
    ]
    
    fileprivate lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 34.0, weight: .semibold)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.text = NSLocalizedString("welcome_title", comment: "")
        return $0
    } (UILabel())
    
    fileprivate lazy var appLabel: UILabel = {
        $0.font = .systemFont(ofSize: 34.0, weight: .semibold)
        $0.textAlignment = .center
        $0.textColor = .tintColor
        $0.numberOfLines = 1
        $0.text = Bundle.main.displayName
        return $0
    } (UILabel())
    
    private lazy var scrollView : UIScrollView = {
        $0.backgroundColor = .clear
        return $0
    } (UIScrollView())
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = cellHeight
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.sectionHeaderTopPadding = CGFloat.leastNormalMagnitude
        $0.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        $0.sectionFooterHeight = CGFloat.leastNormalMagnitude
        $0.register(WelcomeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(WelcomeTableViewCell.self))
        return $0
    } (UITableView(frame: .zero, style: .plain))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(appLabel)
        scrollView.addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: bounds.size.width, height: labelHeight * 2 + verticalPadding * 2 + cellHeight * CGFloat(featureInfos.count))
        titleLabel.frame = CGRect(x: 0, y: verticalPadding, width: bounds.size.width, height: labelHeight)
        appLabel.frame = CGRect(x: 0, y: labelHeight + verticalPadding, width: bounds.size.width, height: labelHeight)
        tableView.frame = CGRect(x: UIDefine.defaultMargin, y: (labelHeight + verticalPadding) * 2.0, width: bounds.size.width - 2 * UIDefine.defaultMargin, height: cellHeight * CGFloat(featureInfos.count))
    }
}

extension WelcomeView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featureInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(WelcomeTableViewCell.self), for: indexPath) as! WelcomeTableViewCell
        cell.setupInfo(featureInfos[indexPath.item])
        return cell
    }
}

class WelcomeViewController: BaseViewController {
    
    fileprivate lazy var mainView : WelcomeView = {
        $0.backgroundColor = .clear
        return $0
    } (WelcomeView())
    
    fileprivate lazy var bottomView : UIView = {
        $0.backgroundColor = .clear
        return $0
    } (UIView())
    
    fileprivate lazy var blurView : UIVisualEffectView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial)))
    
    fileprivate lazy var nextButton : UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = NSLocalizedString("welcome_button_title", comment: "")
        $0.configuration = config
        $0.addTarget(self, action: #selector(didClickNext), for: .touchUpInside)
        return $0
    } (UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        bottomView.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bottomView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func didClickNext() {
        WelcomeManager.isRegisteredUser(true)
        self.dismiss(animated: true)
    }
}
