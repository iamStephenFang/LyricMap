//
//  ARLyricViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/16.
//

import UIKit
import ARKit
import RealityKit
import Photos
import Toast

enum ARLyricViewControllerLayoutInfo {
    static let buttonSize = CGFloat(60)
}

class ARLyricViewController: BaseViewController {
    
    static let iconConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 19))
    
    fileprivate var arView: ARView?
    
    fileprivate var catalogButton = ZoomButton(frame: CGRect(x: 0, y: 0, width: ARLyricViewControllerLayoutInfo.buttonSize, height: ARLyricViewControllerLayoutInfo.buttonSize))
    fileprivate var shotButton = ZoomButton(frame: CGRect(x: 0, y: 0, width: ARLyricViewControllerLayoutInfo.buttonSize, height: ARLyricViewControllerLayoutInfo.buttonSize))
    fileprivate var exitButton = ZoomButton(frame: CGRect(x: 0, y: 0, width: ARLyricViewControllerLayoutInfo.buttonSize, height: ARLyricViewControllerLayoutInfo.buttonSize))
    
    var lyricInfo: LyricInfo?
    
    convenience init(_ info: LyricInfo) {
        self.init()
        
        self.lyricInfo = info
    }
    
    deinit {
        arView?.session.pause()
        arView?.session.delegate = nil
        arView?.scene.anchors.removeAll()
        arView?.removeFromSuperview()
        arView?.window?.resignKey()
        arView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds)
        view.addSubview(arView!)
        
        shotButton.setImage(UIImage(systemName: "camera.fill", withConfiguration: ARLyricViewController.iconConfig), for: .normal)
        shotButton.addBlurEffect()
        shotButton.layer.cornerRadius = ARLyricViewControllerLayoutInfo.buttonSize / 2
        shotButton.clipsToBounds = true
        shotButton.addTarget(self, action: #selector(didClickShotButton), for: .touchUpInside)
        view.addSubview(shotButton)
        shotButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(ARLyricViewControllerLayoutInfo.buttonSize)
        }
        
        catalogButton.setImage(UIImage(systemName: "info.circle", withConfiguration: ARLyricViewController.iconConfig), for: .normal)
        catalogButton.addBlurEffect()
        catalogButton.layer.cornerRadius = ARLyricViewControllerLayoutInfo.buttonSize / 2
        catalogButton.clipsToBounds = true
        catalogButton.addTarget(self, action: #selector(didClickCatalogButton), for: .touchUpInside)
        view.addSubview(catalogButton)
        catalogButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(shotButton.snp.right).offset(ARLyricViewControllerLayoutInfo.buttonSize)
            make.height.width.equalTo(ARLyricViewControllerLayoutInfo.buttonSize)
        }
        
        exitButton.setImage(UIImage(systemName: "xmark", withConfiguration: ARLyricViewController.iconConfig), for: .normal)
        exitButton.addBlurEffect()
        exitButton.layer.cornerRadius = ARLyricViewControllerLayoutInfo.buttonSize / 2
        exitButton.clipsToBounds = true
        exitButton.addTarget(self, action: #selector(didClickExitButton), for: .touchUpInside)
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalTo(shotButton.snp.left).offset(-ARLyricViewControllerLayoutInfo.buttonSize)
            make.height.width.equalTo(ARLyricViewControllerLayoutInfo.buttonSize)
        }
        
        updateLyric()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView?.session.pause()
    }
    
    private func updateLyric() {
        arView?.scene.anchors.removeAll()
        
        let anchor = AnchorEntity()
        let text = MeshResource.generateText(
            lyricInfo?.content ?? "只求你有快樂人生",
            extrusionDepth: 0.08,
            font: .systemFont(ofSize: 0.4, weight: .bold)
        )
        
        let shader = SimpleMaterial(color: .white, roughness: 1, isMetallic: true)
        let textEntity = ModelEntity(mesh: text, materials: [shader])
        
        textEntity.position.z -= 1
        textEntity.setParent(anchor)
        arView?.scene.addAnchor(anchor)
    }
    
    // MARK: Locations
    
    @objc func didClickShotButton() {
        UIGraphicsBeginImageContextWithOptions(arView!.bounds.size, false, 0.0)
        arView?.drawHierarchy(in: arView!.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: img!)
        }, completionHandler: { success, error in
            if error != nil {
                DispatchQueue.main.async {
                    let toast = Toast.default(
                        image: UIImage(systemName: "location.slash")!,
                        title: NSLocalizedString("image_failed_title", comment: ""),
                        subtitle: NSLocalizedString("image_failed_subtitle", comment: "")
                    )
                    toast.show()
                }
            } else {
                DispatchQueue.main.async {
                    let toast = Toast.default(image: UIImage(systemName: "location.slash")!, title: NSLocalizedString("image_success_title", comment: ""))
                    toast.show()
                }
            }
        })
    }
    
    @objc func didClickExitButton() {
        dismiss(animated: true)
    }
    
    @objc func didClickCatalogButton() {
        guard let info = lyricInfo else {
            return
        }
        let infoView = LyricModalView(lyricInfo: info)
        infoView.showWithAnimation(self.view)
    }
}
