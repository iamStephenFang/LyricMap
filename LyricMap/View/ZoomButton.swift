//
//  ZoomButton.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/22.
//

import UIKit

class ZoomButton : UIButton {
    public lazy var zoomHelper: ViewZoomHelper = {
        return ViewZoomHelper()
    }()
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                if isHighlighted {
                    self.zoomHelper.zoomOutWithView(view: self)
                } else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    self.zoomHelper.zoomInWithView(view: self)
                }
            }
        }
    }
}
