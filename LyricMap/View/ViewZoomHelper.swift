//
//  ViewZoomHelper.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/22.
//

import UIKit

@objcMembers
open class ViewZoomHelper: NSObject {
    
    public var zoomDuration: TimeInterval = 0.15
    public var zoomMinDuration: TimeInterval = 0.05
    public var zoomScale: TimeInterval = 0.96
    public var zoomAlpha: TimeInterval = 0.8
    
    public typealias ViewZoomHelperCompleteBlock = (_ finished: Bool)->Void
    
    /// 缩小
    public func zoomOutWithView(view: UIView) {
        self.zoomOutWithView(view: view, completionBlock: nil)
    }
    
    public func zoomOutWithView(view: UIView, completionBlock: ViewZoomHelperCompleteBlock?) {
        view.layer.removeAllAnimations()
        
        CATransaction.setCompletionBlock {
            if let block = completionBlock {
                block(true)
            }
        }
        CATransaction.begin()
        
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.duration = self.zoomDuration
        scaleAnim.fromValue = 1
        scaleAnim.toValue = self.zoomScale
        scaleAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 1, 0.25, 1)
        
        let opactityAnim = CABasicAnimation(keyPath: "opacity")
        opactityAnim.duration = self.zoomDuration
        opactityAnim.fromValue = 1
        opactityAnim.toValue = self.zoomAlpha
        opactityAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 1, 0.25, 1)
        
        let groupAnim = CAAnimationGroup.init()
        groupAnim.animations = [scaleAnim, opactityAnim]
        groupAnim.duration = self.zoomDuration
        groupAnim.isRemovedOnCompletion = false
        groupAnim.fillMode = .forwards
        view.layer.add(groupAnim, forKey: "zoomOutAnim")
        
        CATransaction.commit()
    }
    
    ///放大
    public func zoomInWithView(view: UIView) {
        self.zoomInWithView(view: view, completionBlock: nil)
    }
    
    public func zoomInWithView(view: UIView, completionBlock: ViewZoomHelperCompleteBlock?) {
        let delayTime = self.zoomMinDuration

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delayTime * 1000))) {
            view.layer.removeAllAnimations()
            
            CATransaction.setCompletionBlock {
                if let block = completionBlock {
                    block(true)
                }
            }
            CATransaction.begin()
            
            let scaleAnim = CABasicAnimation.init(keyPath: "transform.scale")
            scaleAnim.duration = self.zoomDuration
            scaleAnim.fromValue = self.zoomScale
            scaleAnim.toValue = 1
            scaleAnim.timingFunction = CAMediaTimingFunction.init(controlPoints: 0.25, 1, 0.25, 1)
            
            let opactityAnim = CABasicAnimation.init(keyPath: "opacity")
            opactityAnim.duration = self.zoomDuration
            opactityAnim.fromValue = self.zoomAlpha
            opactityAnim.toValue = 1
            opactityAnim.timingFunction = CAMediaTimingFunction.init(controlPoints: 0.25, 1, 0.25, 1)
            
            let groupAnim = CAAnimationGroup.init()
            groupAnim.animations = [scaleAnim, opactityAnim]
            groupAnim.duration = self.zoomDuration
            view.layer.add(groupAnim, forKey: "zoomInAnim")
            
            CATransaction.commit()
        }
    }
}
