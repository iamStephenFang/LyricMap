//
//  SettingViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/24.
//

import Foundation

class SettingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "Setting")
        setupDismissButton()
        navigationItem.largeTitleDisplayMode = .never
    }
}
