//
//  CustomShareView.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit

class CustomShareView : UIView {
    
    fileprivate lazy var blurView : UIVisualEffectView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial)))
    
    private let configuration = UIImage.SymbolConfiguration(pointSize: 19, weight: .medium)
    
    fileprivate lazy var backgroundButton : UIButton = {
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(cancelShare), for: .touchUpInside)
        return $0
    } (UIButton())
    
    fileprivate lazy var cancelButton : ZoomButton = {
        $0.backgroundColor = .systemFill
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        $0.tintColor = .tintColor
        $0.layer.cornerRadius = UIDefine.buttonSize / 2
        $0.addTarget(self, action: #selector(cancelShare), for: .touchUpInside)
        return $0
    } (ZoomButton())
    
    fileprivate lazy var sendButton : ZoomButton = {
        $0.backgroundColor = .systemFill
        $0.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        $0.tintColor = .tintColor
        $0.layer.cornerRadius = UIDefine.buttonSize / 2
        $0.addTarget(self, action: #selector(sendContent), for: .touchUpInside)
        return $0
    } (ZoomButton())
    
    fileprivate lazy var saveButton : ZoomButton = {
        $0.backgroundColor = .systemFill
        $0.setImage(UIImage(systemName: "square.and.arrow.down", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setImage(UIImage(systemName: "square.and.arrow.down", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        $0.tintColor = .tintColor
        $0.layer.cornerRadius = UIDefine.buttonSize / 2
        $0.addTarget(self, action: #selector(saveContent), for: .touchUpInside)
        return $0
    } (ZoomButton())
    
    fileprivate lazy var contentView : UIView = {
        $0.layer.cornerRadius = 20.0
        $0.clipsToBounds = true
        $0.backgroundColor = .tintColor
        return $0
    } (UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(blurView)
        addSubview(backgroundButton)
        backgroundButton.addSubview(contentView)
        backgroundButton.addSubview(saveButton)
        backgroundButton.addSubview(sendButton)
        backgroundButton.addSubview(cancelButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurView.frame = self.bounds
        backgroundButton.frame = self.bounds
        
        let contentViewWidth = self.bounds.width - UIDefine.defaultMargin * 2
        let contentViewHeight = contentViewWidth * 1.2
        let contentViewTop = self.bounds.height * 0.2
        let buttonViewTop = self.bounds.height * 0.3 + contentViewHeight
        let buttonViewInset = (contentViewWidth - UIDefine.buttonSize * 3) / 4
        contentView.frame = CGRect(x: UIDefine.defaultMargin, y: contentViewTop, width: contentViewWidth, height: contentViewHeight)
        saveButton.frame = CGRect(x: buttonViewInset + UIDefine.defaultMargin, y: buttonViewTop, width: UIDefine.buttonSize, height: UIDefine.buttonSize)
        sendButton.frame = CGRect(x: buttonViewInset * 2 + UIDefine.defaultMargin + UIDefine.buttonSize, y: buttonViewTop, width: UIDefine.buttonSize, height: UIDefine.buttonSize)
        cancelButton.frame = CGRect(x: buttonViewInset * 3 + UIDefine.defaultMargin + UIDefine.buttonSize * 2, y: buttonViewTop, width: UIDefine.buttonSize, height: UIDefine.buttonSize)
    }
    
    // MARK: LifeCycle
    
    func showWithAnimation(_ view: UIView) {
        view.addSubview(self)
        self.frame = view.bounds
        
        contentView.alpha = 0.0
        sendButton.alpha = 0.0
        saveButton.alpha = 0.0
        cancelButton.alpha = 0.0
        blurView.effect = nil
        
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.contentView.alpha = 1.0
            self.sendButton.alpha = 1.0
            self.saveButton.alpha = 1.0
            self.cancelButton.alpha = 1.0
            self.blurView.effect = UIBlurEffect(style: .systemMaterial)
        } completion: { finished in
            
        }
    }
    
    func dismiss() {
        contentView.alpha = 1.0
        sendButton.alpha = 1.0
        saveButton.alpha = 1.0
        cancelButton.alpha = 1.0
        blurView.effect = UIBlurEffect(style: .systemMaterial)
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.contentView.alpha = 0.0
            self.sendButton.alpha = 0.0
            self.saveButton.alpha = 0.0
            self.cancelButton.alpha = 0.0
            self.blurView.effect = nil
        } completion: { finished in
            self.removeFromSuperview()
        }
    }
    
    // MARK: Action
    
    @objc private func cancelShare() {
        dismiss()
    }
    
    @objc private func sendContent() {
        let activityViewController = UIActivityViewController(activityItems: [NSLocalizedString("SideBar.Share.Word", comment: ""), URL(string: "https://www.apple.com")!], applicationActivities: nil)
        self.window?.rootViewController?.present(activityViewController, animated: true, completion: {
            self.dismiss()
        })
    }
    
    @objc private func saveContent() {
        
    }
}

