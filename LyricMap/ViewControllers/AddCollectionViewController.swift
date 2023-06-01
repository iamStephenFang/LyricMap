//
//  AddCollectionViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/22.
//

import UIKit
import SnapKit
import PhotosUI

class AddCollectionViewController: BaseViewController {
    
    let textField = UITextField()
    let descField = UITextField()
    let imageView = UIImageView()
    
    private var selectedAssetIdentifiers = [String]()
    private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    private var selection = [String: PHPickerResult]()
    
    static let iconConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "New collection")
        setNavigationRightBar(item: UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCollection)))
        setupDismissButton()
        
        imageView.image = UIImage(named: "PlaceHolder")
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        let pickerButton = UIButton(type: .system)
        pickerButton.setImage(UIImage(systemName: "photo.circle", withConfiguration: AddCollectionViewController.iconConfig), for: .normal)
        pickerButton.addTarget(self, action: #selector(showPhotoPicker), for: .touchUpInside)
        view.addSubview(pickerButton)
        pickerButton.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.height.equalTo(100)
        }

        textField.placeholder = "Collection Name"
        textField.textAlignment = .center
        textField.becomeFirstResponder()
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descField.placeholder = "Description"
        descField.textAlignment = .center
        view.addSubview(descField)
        descField.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    @objc func showPhotoPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.preferredAssetRepresentationMode = .current
        configuration.selection = .ordered
        configuration.selectionLimit = 3
        configuration.preselectedAssetIdentifiers = self.selectedAssetIdentifiers
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func saveCollection() {
        
    }
}

extension AddCollectionViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = existingSelection[identifier] ?? result
        }
        
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()
    }
}
