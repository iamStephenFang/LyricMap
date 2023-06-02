//
//  SettingAppearanceViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit

class SettingAppearanceViewController: SettingBaseViewController {

    fileprivate let themeManager = ThemeManager()
    fileprivate let themeInfos = [
        NSLocalizedString("setting_appearance_theme_system", comment: ""),
        NSLocalizedString("setting_appearance_theme_light", comment: ""),
        NSLocalizedString("setting_appearance_theme_dark", comment: ""),
    ]
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.delegate = self
        $0.dataSource = self
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = UIDefine.cellHeight
        return $0
    } (UITableView(frame: .zero, style: .insetGrouped))
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(themeStatusChanged), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        setNavigationTitle(title: NSLocalizedString("setting_appearance_title", comment: ""))
    
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.register(SelectionTableViewCell.self, forCellReuseIdentifier: SelectionTableViewCell.reuseIdentifier)
        tableView.selectRow(at: currentThemeIndex(), animated: false, scrollPosition: .top)
    }
    
    @objc private func themeStatusChanged() {
        self.themeManager.updateTheme(themeManager.currentTheme())
    }
    
    private func currentThemeIndex() -> IndexPath {
        switch themeManager.currentTheme() {
        case .system:
            return IndexPath(item: 0, section: 0)
        case .light:
            return IndexPath(item: 1, section: 0)
        case .dark:
            return IndexPath(item: 2, section: 0)
        }
    }
}

extension SettingAppearanceViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = themeInfos[indexPath.item]
        return cell
    }
}

extension SettingAppearanceViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self.themeManager.updateTheme(Theme.system)
            tableView.deselectRow(at: IndexPath(item: 1, section: indexPath.section), animated: false)
            tableView.deselectRow(at: IndexPath(item: 2, section: indexPath.section), animated: false)
        case 1:
            self.themeManager.updateTheme(Theme.light)
            tableView.deselectRow(at: IndexPath(item: 0, section: indexPath.section), animated: false)
            tableView.deselectRow(at: IndexPath(item: 2, section: indexPath.section), animated: false)
        case 2:
            self.themeManager.updateTheme(Theme.dark)
            tableView.deselectRow(at: IndexPath(item: 0, section: indexPath.section), animated: false)
            tableView.deselectRow(at: IndexPath(item: 1, section: indexPath.section), animated: false)
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("setting_appearance_theme", comment: "")
    }
}

