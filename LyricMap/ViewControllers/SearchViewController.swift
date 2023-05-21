//
//  SearchViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/11.
//

import UIKit

class SearchViewController: BaseViewController {
    
    fileprivate lazy var searchController: UISearchController = { [unowned self] in
        $0.searchBar.placeholder = "Search lyric, place, song and more"
        $0.searchBar.searchTextField.clearButtonMode = .whileEditing
        $0.searchResultsUpdater = self
        return $0
    }(UISearchController(searchResultsController: nil))
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
//        $0.delegate = self
//        $0.dataSource = self
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = UIDefine.cellHeight
        $0.sectionHeaderTopPadding = CGFloat.leastNormalMagnitude
        $0.sectionHeaderHeight = UIDefine.verticalMargin
        $0.sectionFooterHeight = CGFloat.leastNormalMagnitude
        $0.allowsMultipleSelection = true
        $0.showsVerticalScrollIndicator = false
        return $0
    } (UITableView(frame: .zero, style: .insetGrouped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "Search")
        navigationItem.searchController = searchController
    }
    
    private func setupTableVC() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setNeedsReload() {
        guard let keyword = searchController.searchBar.text, keyword.count > 0 else {
            tableView.reloadData()
            return
        }
        
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        setNeedsReload()
    }
}
