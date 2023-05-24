//
//  CollectionViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import Foundation

class CollectionViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Collection")
        navigationItem.largeTitleDisplayMode = .never
    }
}
