//
//  BookmarkViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/11.
//

import UIKit

class BookmarkViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "Bookmarks")
        setNavigationRightBar(items:
                                [
                                    UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addCollection))])
    }
    
    // MARK: Actions
    
    @objc private func addCollection() {
        present(CollectionViewController(), animated: true)
    }
    
    @objc private func editCollection() {
        
    }
}
