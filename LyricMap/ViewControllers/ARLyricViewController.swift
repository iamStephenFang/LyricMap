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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds)
        view.addSubview(arView)
        arView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        updateLyric()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.session.pause()
    }
    
    private func updateLyric() {
        arView.scene.anchors.removeAll()
        
        let anchor = AnchorEntity()
        let text = MeshResource.generateText(
            "只求你有快樂人生",
            extrusionDepth: 0.08,
            font: .systemFont(ofSize: 0.4, weight: .bold)
        )
        
        let shader = SimpleMaterial(color: .white, roughness: 1, isMetallic: true)
        let textEntity = ModelEntity(mesh: text, materials: [shader])
        
        textEntity.position.z -= 1
        textEntity.setParent(anchor)
        arView.scene.addAnchor(anchor)
    }
}
