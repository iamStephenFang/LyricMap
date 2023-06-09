//
//  TabViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/10.
//

import UIKit

class TabViewController: UITabBarController {

    static let iconConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 19))
    static let selectedIconConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 21, weight: .semibold))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        viewControllers = [
            createNavController(for: DiscoverViewController(),tag: 1,  image: UIImage(systemName: "safari")!, selectedImage: UIImage(systemName: "safari.fill")!),
            createNavController(for: MapViewController(), tag: 0,  image: UIImage(systemName: "map")!, selectedImage: UIImage(systemName: "map.fill")!),
            createNavController(for: LibraryViewController(), tag: 2,  image: UIImage(systemName: "bookmark")!, selectedImage: UIImage(systemName: "bookmark.fill")!),
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     tag: Int,
                                     image: UIImage,
                                     selectedImage: UIImage) -> UIViewController {        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.tag = tag
        navController.tabBarItem.image = image.withConfiguration(TabViewController.iconConfig).imageWithoutBaseline()
        navController.tabBarItem.selectedImage = selectedImage.withConfiguration( TabViewController.selectedIconConfig).imageWithoutBaseline().withTintColor(.tintColor, renderingMode: .alwaysOriginal)
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return navController
    }
}


// MARK: - UITabBarControllerDelegate

extension TabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        return true
    }
}
