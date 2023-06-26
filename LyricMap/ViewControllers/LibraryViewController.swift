//
//  LibraryViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/11.
//

import UIKit

class LibraryViewController: BaseViewController {
    
    var lyricCollections = [
        [
            LyricCollection(id: 0, type: .favorited, title: NSLocalizedString("library_favorited_title", comment: ""), subtitle: NSLocalizedString("library_favorited_subtitle", comment: ""), imageName: "Favorite", infos: []),
            LyricCollection(id: 1, type: .visited, title: NSLocalizedString("library_visited_title", comment: ""), subtitle: NSLocalizedString("library_visited_subtitle", comment: ""), imageName: "Pinned", infos: []),
        ],
        [
            LyricCollection(id: 2, type: .custom, title: "Custom", subtitle: "Custom Playlist", imageName: "PlaceHolder", infos: []),
        ],
    ]
    
    fileprivate var collectionView: UICollectionView!
    
    fileprivate lazy var searchController: UISearchController = { [unowned self] in
        $0.searchBar.placeholder = NSLocalizedString("library_search_placeholder", comment: "")
        $0.searchBar.searchTextField.clearButtonMode = .whileEditing
        $0.searchResultsUpdater = self
        return $0
    }(UISearchController(searchResultsController: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: NSLocalizedString("library_title", comment: ""))
        setNavigationRightBar(items:
                                [
                                    UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didToggleSetting)),
                                    UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didToggleAdd))])
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(215))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(30))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
    
        let layout = UICollectionViewCompositionalLayout(section: layoutSection, configuration: config)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(LyricCollectionViewCell.self, forCellWithReuseIdentifier: LyricCollectionViewCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.reloadData()
    }
    
    private func setNeedsReload() {
        guard let keyword = searchController.searchBar.text, keyword.count > 0 else {
            return
        }
    }
    
    // MARK: Actions
    @objc private func didToggleAdd() {
        let containerViewController = CollectionEditorViewController()
        present(UINavigationController(rootViewController: containerViewController), animated: true)
    }
    
    @objc private func didToggleSetting() {
        let containerViewController = SettingViewController()
        present(UINavigationController(rootViewController: containerViewController), animated: true)
    }
}

extension LibraryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        setNeedsReload()
    }
}

extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lyricCollections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LyricCollectionViewCell.reuseIdentifier, for: indexPath) as! LyricCollectionViewCell
        cell.configure(with: lyricCollections[indexPath.section][indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
        if indexPath.section == 0 {
            sectionHeader.title.text = NSLocalizedString("library_pinned_title", comment: "")
        } else {
            sectionHeader.title.text = NSLocalizedString("library_collected_title", comment: "")
        }
        
        return sectionHeader
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.item == 0 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.shared().favoritedList, title: NSLocalizedString("library_favorited_title", comment: "")), animated: true)
            } else if indexPath.item == 1 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.shared().visitedList, title: NSLocalizedString("library_visited_title", comment: "")), animated: true)
            } else {
                navigationController?.pushViewController(CollectionViewController(), animated: true)
            }
        case 1:
            navigationController?.pushViewController(CollectionViewController(), animated: true)
        default:
            navigationController?.pushViewController(CollectionViewController(), animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        let helper = ViewZoomHelper()
        helper.zoomOutWithView(view: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        let helper = ViewZoomHelper()
        helper.zoomInWithView(view: cell)
    }
}
