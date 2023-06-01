//
//  NearbyPlacesViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import UIKit

class NearbyPlacesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
    }
}
