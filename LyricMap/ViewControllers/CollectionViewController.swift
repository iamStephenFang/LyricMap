//
//  CollectionViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import UIKit

class CollectionViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "Collection")
        setNavigationRightBar(item: UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCollection)))
    }
    
    @objc func editCollection() {
        
    }
}
