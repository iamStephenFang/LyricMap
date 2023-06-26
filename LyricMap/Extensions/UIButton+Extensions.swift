//
//  UIButton+Extensions.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/26.
//

import Foundation
import UIKit

extension UIButton
{
    func addBlurEffect()
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}
