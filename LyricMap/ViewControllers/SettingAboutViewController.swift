//
//  SettingAboutViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit

class SettingAboutViewController: SettingBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: NSLocalizedString("setting_about_title", comment: ""))
        setupHeader()
        setupCells()
    }
    
    private func setupHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 30, width: view.frame.width, height: 120))
        let logoView = UIImageView(image: UIImage(named: "LaunchIcon"))
        headerView.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.center.equalTo(headerView)
            make.size.equalTo(CGSize(width: 90, height: 90))
        }
        sectionVC.tableView.tableHeaderView = headerView
    }
    
    private func setupCells () {
        sectionVC.cellItems = [
            [
                StaticTableViewCellItem(title: NSLocalizedString("setting_about_version", comment: ""), accessoryText: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, selectionHandler: nil),
                StaticTableViewCellItem(title: NSLocalizedString("setting_about_website", comment: ""), accessoryType: .disclosureIndicator, selectionHandler: { item in
                    self.openURL("https://apple.com.cn")
                }),
                StaticTableViewCellItem(title: NSLocalizedString("setting_about_privacy", comment: ""), accessoryType: .disclosureIndicator, selectionHandler: { [weak self] item in
                    self?.navigationController?.pushViewController(SettingAgreementViewController(), animated: true)
                }),
                StaticTableViewCellItem(title: NSLocalizedString("setting_about_agreements", comment: ""), accessoryType: .disclosureIndicator, selectionHandler: { [weak self] item in
                    self?.navigationController?.pushViewController(SettingAgreementViewController(), animated: true)
                }),
                StaticTableViewCellItem(title:NSLocalizedString("setting_about_changelog", comment: ""),
                                        accessoryType: .disclosureIndicator,
                                          selectionHandler: { item in
                    self.openURL("https://lyricmap.canny.io/changelog")
                })
            ],
            [
                StaticTableViewCellItem(title:NSLocalizedString("setting_about_feedback", comment: ""),
                                          accessoryText: "costmator.canny.io",
                                          selectionHandler: { item in
                    self.openURL("https://lyricmap.canny.io/")
                }),
                StaticTableViewCellItem(title: NSLocalizedString("setting_about_mail", comment: ""),
                                          accessoryText: "lyricmap@stephenfang.me",
                                          selectionHandler: { item in
                    self.openURL("mailto:LyricMap@stephenfang.me?subject=LyricMap%20Feedback&body=Write%20your%20feedback%20here.")
                }),
            ],
        ]
    }
}
