//
//  SettingBaseViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit

class SettingBaseViewController: UIViewController {
    
    public var sectionVC = StaticTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        setupSectionVC()
    }
    
    private func setupSectionVC () {
        sectionVC.tableView.separatorColor = .clear
        view.addSubview(sectionVC.view)
        sectionVC.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
