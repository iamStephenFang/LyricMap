//
//  UIViewController+Extensions.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import UIKit

extension UIViewController {
    
    func setNavigationTitle(title: String) {
        self.navigationItem.title = title
    }
    
    func setNavigationTitleView(view: UIView) {
        self.navigationItem.titleView = view
    }
    
    func setNavigationLeftBar(item: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItem = item
    }
    
    func setNavigationRightBar(item: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = item
    }
    
    func setNavigationRightBar(items: [UIBarButtonItem]?) {
        self.navigationItem.rightBarButtonItems = items
    }
    
    func setNavigationLeftBar(items: [UIBarButtonItem]?) {
        self.navigationItem.leftBarButtonItems = items
    }
    
    func setNavigationToolBarItems(items: [UIBarButtonItem]) {
        let seperatorItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolbarItems = [seperatorItem] + items +  [seperatorItem]
        navigationController?.isToolbarHidden = false
    }
    
    func setupDismissButton() {
        let dismissButton = ZoomButton()
        dismissButton.setImage(UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)).withRenderingMode(.alwaysOriginal), for: .normal)
        dismissButton.addTarget(self, action: #selector(toggleDismiss), for: .touchUpInside)
        setNavigationLeftBar(item: UIBarButtonItem(customView: dismissButton))
    }
    
    // MARK: Actions
    @objc private func toggleDismiss() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss(animated: true, completion: nil)
    }
}
