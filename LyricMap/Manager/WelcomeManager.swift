//
//  WelcomeManager.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import UIKit

class WelcomeManager {
    
    static let shared: WelcomeManager = {
        let instance = WelcomeManager()
        return instance
    }()
    
    public class func isRegisteredUser() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaults.Key.isRegisteredUser.rawValue)
    }

    public class func isRegisteredUser(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: .isRegisteredUser)
    }
    
    public class func start() {
        if !WelcomeManager.isRegisteredUser() {
            if let viewController = UIApplication.topViewController() {
                if (shared.noOnBoardingPresented(viewController)) {
                    shared.presentOnBoarding(viewController)
                }
            }
        }
    }
    
    private func presentOnBoarding(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            let navController = UINavigationController(rootViewController: WelcomeViewController())
            navController.isModalInPresentation = true
            viewController.present(navController, animated: false)
        }
    }
    
    private func noOnBoardingPresented(_ viewController: UIViewController) -> Bool {
        var result = true
        if let navigationController = viewController as? UINavigationController {
            if let presentedView = navigationController.viewControllers.first {
                if (presentedView is WelcomeViewController)    { result = false }
            }
        }
        return result
    }
}
