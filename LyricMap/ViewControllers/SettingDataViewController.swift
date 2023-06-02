//
//  SettingDataViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/2.
//

import UIKit
import SDWebImage

class SettingDataViewController: SettingBaseViewController {
    
    fileprivate let dataSyncSwitchCell = StaticTableViewCellItem(title: NSLocalizedString("setting_data_icloud" , comment: ""), imageName: "icloud", accessoryView: {
        let switchView = UISwitch()
        switchView.onTintColor = .tintColor
        switchView.isEnabled = true
        switchView.isOn = false
        switchView.sizeToFit()
        switchView.addTarget(SettingDataViewController.self, action: #selector(switchDataSync), for: .valueChanged)
        return switchView
    }())
    
    fileprivate lazy var resetDataCell : StaticTableViewCellItem = { return  StaticTableViewCellItem(title: NSLocalizedString("setting_data_delete" , comment: ""), image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysTemplate).withConfiguration(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))),  accessoryType: UITableViewCell.AccessoryType.none,  selectionHandler: { item in
        let alert = UIAlertController(title: NSLocalizedString("setting_data_delete_title", comment: ""),
                                      message: NSLocalizedString("setting_data_delete_subtitle", comment: ""),
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("setting_data_deletefavorites", comment: ""),
                                      style: .destructive,
                                      handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("setting_data_deletevisited", comment: ""),
                                      style: .destructive,
                                      handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("setting_data_deleteall", comment: ""),
                                      style: .destructive,
                                      handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""),
                                      style: .cancel,
                                      handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }) } ()
    
    fileprivate lazy var resetCacheCell : StaticTableViewCellItem = { return  StaticTableViewCellItem(title: NSLocalizedString("setting_data_cache" , comment: ""), image: UIImage(systemName: "clear")?.withTintColor(.red, renderingMode: .alwaysTemplate).withConfiguration(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))),  accessoryType: UITableViewCell.AccessoryType.none,  selectionHandler: { item in
        let alert = UIAlertController(title: NSLocalizedString("setting_data_cleancache_title", comment: ""), message: NSLocalizedString("setting_data_cleancache_subtitle", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert_confirm", comment: ""), style: .destructive,
                                      handler: { _ in
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""),
                                      style: .cancel,
                                      handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }) } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: NSLocalizedString("setting_data_title", comment: ""))
        setupCells()
    }
    
    private func setupCells () {
        sectionVC.cellItems = [
            [
                self.dataSyncSwitchCell
            ],
            [
                self.resetCacheCell
            ],
            [
                self.resetDataCell
            ],
        ]
    }
    
    @objc private func switchDataSync() {
        
    }
}

