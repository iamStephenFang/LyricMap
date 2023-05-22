//
//  AddCollectionViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/22.
//

import UIKit

class AddCollectionViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "New collection")
        setupDismissButton()
        navigationItem.largeTitleDisplayMode = .never
    }
}
