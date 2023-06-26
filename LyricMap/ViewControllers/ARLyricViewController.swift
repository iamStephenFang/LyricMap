//
//  ARLyricViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/16.
//

import UIKit
import ARKit
import RealityKit

class ARLyricViewController: BaseViewController {
    
    fileprivate var arView: ARView!
    
    fileprivate var catalogButton: ZoomButton!
    fileprivate var shotButton: ZoomButton!
    fileprivate var exitButton: ZoomButton!
    
    var lyric: String = "只求你有快樂人生"
    
    convenience init(_ info: LyricInfo) {
        self.init()
        
        self.lyric = info.content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds)
        view.addSubview(arView)
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        
        shotButton = ZoomButton()
        shotButton.configuration = config
        shotButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        shotButton.addTarget(self, action: #selector(didClickShotButton), for: .touchUpInside)
        view.addSubview(shotButton)
        shotButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(UIDefine.buttonSize)
        }
        
        catalogButton = ZoomButton()
        catalogButton.configuration = config
        catalogButton.setImage(UIImage(systemName: "list.bullet.circle.fill"), for: .normal)
        catalogButton.addTarget(self, action: #selector(didClickShotButton), for: .touchUpInside)
        view.addSubview(catalogButton)
        catalogButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(shotButton.snp.right).offset(UIDefine.buttonSize)
            make.height.width.equalTo(UIDefine.buttonSize)
        }
        
        exitButton = ZoomButton()
        exitButton.configuration = config
        exitButton.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        exitButton.addTarget(self, action: #selector(didClickExitButton), for: .touchUpInside)
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalTo(shotButton.snp.left).offset(-UIDefine.buttonSize)
            make.height.width.equalTo(UIDefine.buttonSize)
        }
        
        updateLyric()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.session.pause()
    }
    
    private func updateLyric() {
        arView.scene.anchors.removeAll()
        
        let anchor = AnchorEntity()
        let text = MeshResource.generateText(
            lyric,
            extrusionDepth: 0.08,
            font: .systemFont(ofSize: 0.4, weight: .bold)
        )
        
        let shader = SimpleMaterial(color: .white, roughness: 1, isMetallic: true)
        let textEntity = ModelEntity(mesh: text, materials: [shader])
        
        textEntity.position.z -= 1
        textEntity.setParent(anchor)
        arView.scene.addAnchor(anchor)
    }
    
    // MARK: Locations
    
    @objc func didClickShotButton() {
        if let img = arView.session.currentFrame?.capturedImage {
            let ciimg = CIImage(cvImageBuffer: img)
            let finImage = UIImage(ciImage: ciimg)
            
        }
    }
    
    @objc func didClickExitButton() {
        dismiss(animated: true)
    }
}
