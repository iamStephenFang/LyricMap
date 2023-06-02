//
//  SettingViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/24.
//

import Foundation
import UIKit


class SettingViewController: SettingBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: NSLocalizedString("setting_title", comment: ""))
        setupDismissButton()
        
        sectionVC.cellItems = [
            [
                StaticTableViewCellItem(title: NSLocalizedString("setting_data_title", comment: ""), imageName: "icloud", accessoryType: .disclosureIndicator, selectionHandler: { item in
                    self.navigationController?.pushViewController(SettingDataViewController(), animated: true)
                }), StaticTableViewCellItem(title: NSLocalizedString("setting_appearance_title", comment: ""), imageName: "paintbrush", accessoryType: .disclosureIndicator, selectionHandler: { item in
                    self.navigationController?.pushViewController(SettingDataViewController(), animated: true)
                })
            ],
            [
                StaticTableViewCellItem(title: NSLocalizedString("setting_about_title", comment: ""), imageName: "info.circle", accessoryType: .disclosureIndicator, selectionHandler: { item in
                    self.navigationController?.pushViewController(SettingAboutViewController(), animated: true)
                }), StaticTableViewCellItem(title: NSLocalizedString("setting_share_title", comment: ""), imageName:  "square.and.arrow.up", accessoryType: .disclosureIndicator, selectionHandler: { item in
                    let shareView = CustomShareView()
                    shareView.showWithAnimation(self.view)
                }), StaticTableViewCellItem(title: NSLocalizedString("setting_rating_title", comment: ""), imageName:  "hand.thumbsup", accessoryType: .disclosureIndicator, selectionHandler: { item in
                    // TODO: @StephenFang Replace Link
                    var components = URLComponents(url: URL(string: "https://itunes.apple.com/app/id958625272")!, resolvingAgainstBaseURL: false)
                    components?.queryItems = [
                      URLQueryItem(name: "action", value: "write-review")
                    ]
                    
                    guard let writeReviewURL = components?.url else {
                      return
                    }
                    UIApplication.shared.open(writeReviewURL)
                }),
            ]
        ]
    }
}
