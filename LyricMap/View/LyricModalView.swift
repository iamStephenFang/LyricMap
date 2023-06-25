//
//  LyricModalView.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/25.
//

import UIKit

class LyricModalView : UIView {
    
    fileprivate lazy var blurView : UIVisualEffectView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial)))
    
    fileprivate lazy var backgroundButton : UIButton = {
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(cancelShare), for: .touchUpInside)
        return $0
    } (UIButton())
    
    fileprivate lazy var contentView : LyricCalloutView = {
        $0.clipsToBounds = true
        return $0
    } (LyricCalloutView(lyricInfo: self.lyricInfo))
    
    fileprivate let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
    
    fileprivate lazy var cancelButton : ZoomButton = {
        $0.backgroundColor = .systemFill
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .highlighted)
        $0.layer.cornerRadius = UIDefine.buttonSize / 2
        $0.addTarget(self, action: #selector(cancelShare), for: .touchUpInside)
        return $0
    } (ZoomButton())
    
    fileprivate let lyricInfo: LyricInfo
    
    init(lyricInfo: LyricInfo) {
        self.lyricInfo = lyricInfo
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurView.frame = self.bounds
        backgroundButton.frame = self.bounds
        
        let contentViewWidth = self.bounds.width - UIDefine.defaultMargin * 2
        let contentViewHeight = CGFloat(240)
        let contentViewTop = self.bounds.height * 0.3
        let buttonViewTop = self.bounds.height * 0.4 + contentViewTop
        let buttonViewInset = (contentViewWidth - UIDefine.buttonSize * 3) / 4
        contentView.frame = CGRect(x: UIDefine.defaultMargin, y: contentViewTop, width: contentViewWidth, height: contentViewHeight)
        cancelButton.frame = CGRect(x: buttonViewInset * 2 + UIDefine.defaultMargin + UIDefine.buttonSize, y: buttonViewTop, width: UIDefine.buttonSize, height: UIDefine.buttonSize)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(blurView)
        addSubview(backgroundButton)
        backgroundButton.addSubview(contentView)
        backgroundButton.addSubview(cancelButton)
    }
    
    // MARK: LifeCycle
    
    func showWithAnimation(_ view: UIView) {
        view.addSubview(self)
        self.frame = view.bounds
        
        contentView.alpha = 0.0
        cancelButton.alpha = 0.0
        blurView.effect = nil
        
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.contentView.alpha = 1.0
            self.blurView.effect = UIBlurEffect(style: .systemMaterial)
            self.cancelButton.alpha = 1.0
        } completion: { finished in
            
        }
    }
    
    func dismiss() {
        contentView.alpha = 1.0
        cancelButton.alpha = 1.0
        blurView.effect = UIBlurEffect(style: .systemMaterial)
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.contentView.alpha = 0.0
            self.blurView.effect = nil
            self.cancelButton.alpha = 0.0
        } completion: { finished in
            self.removeFromSuperview()
        }
    }
    
    // MARK: Action
    
    @objc private func cancelShare() {
        dismiss()
    }
    
}
