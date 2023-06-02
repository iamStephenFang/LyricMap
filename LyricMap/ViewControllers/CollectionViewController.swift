//
//  CollectionViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import UIKit

class CollectionViewController: BaseViewController {
    
    let infos = LyricInfoManager.infos
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.delegate = self
        $0.dataSource = self
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = UIDefine.cellHeight
        $0.backgroundColor = .clear
        return $0
    } (UITableView(frame: view.bounds, style: .plain))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "Collection")
        setNavigationRightBar(item: UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCollection)))
        
        view.addSubview(tableView)
        tableView.register(SongInfoTableViewCell.self, forCellReuseIdentifier: SongInfoTableViewCell.reuseIdentifier)
    }
    
    @objc func editCollection() {
        
    }
}

extension CollectionViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongInfoTableViewCell.reuseIdentifier, for: indexPath) as! SongInfoTableViewCell
        cell.configure(with: infos[indexPath.item])
        return cell
    }
}

extension CollectionViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let helper = ViewZoomHelper()
        helper.zoomOutWithView(view: cell)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let helper = ViewZoomHelper()
        helper.zoomInWithView(view: cell)
    }
}
