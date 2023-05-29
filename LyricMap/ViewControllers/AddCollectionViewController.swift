//
//  AddCollectionViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/22.
//

import UIKit
import SnapKit
import Photos
import SnapKit

class AddCollectionViewController: BaseViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let photoPicker = UIImagePickerController()
    let textField = UITextField()
    
    static let iconConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "New collection")
        setupDismissButton()
        navigationItem.largeTitleDisplayMode = .never
        
        let leftButton = UIButton(type: .system)
        leftButton.setImage(UIImage(systemName: "photo.circle", withConfiguration: AddCollectionViewController.iconConfig), for: .normal)
        leftButton.addTarget(self, action: #selector(showPhotoPicker), for: .touchUpInside)
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(100)
            make.width.height.equalTo(60)
        }

        textField.delegate = self
        textField.placeholder = "Collection Name"
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalTo(leftButton.snp.right)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(leftButton)
        }

        photoPicker.delegate = self
    }
    
    @objc func showPhotoPicker() {
        photoPicker.sourceType = .photoLibrary
        present(photoPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        }
    }
}
