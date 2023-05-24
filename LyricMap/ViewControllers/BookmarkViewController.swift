//
//  BookmarkViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/11.
//

import UIKit

class BookmarkViewController: BaseViewController {
    
    var lyricCollections = [
        [
            LyricCollection(id: UUID(), title: "Favorites", subtitle: "My Favorite", imageName: "Favorite", infos: []),
            LyricCollection(id: UUID(), title: "Visited", subtitle: "Visited Points", imageName: "Pinned", infos: []),
        ],
        [
            LyricCollection(id: UUID(), title: "Favorites", subtitle: "MyFavorite", imageName: "iOS1", infos: []),
            LyricCollection(id: UUID(), title: "Favorites", subtitle: "MyFavorite", imageName: "iOS2", infos: []),
            LyricCollection(id: UUID(), title: "Favorites", subtitle: "MyFavorite", imageName: "iOS3", infos: []),
        ],
    ]
    
    fileprivate var collectionView: UICollectionView!
    
    fileprivate lazy var searchController: UISearchController = { [unowned self] in
        $0.searchBar.placeholder = "Search lyric, place, song and more"
        $0.searchBar.searchTextField.clearButtonMode = .whileEditing
        $0.searchResultsUpdater = self
        return $0
    }(UISearchController(searchResultsController: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "Bookmark")
        setNavigationRightBar(items:
                                [
                                    UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didToggleSetting)),
                                    UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didToggleAdd))])
        navigationItem.searchController = searchController
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(218))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(50))
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
        let containerViewController = AddCollectionViewController()
        present(UINavigationController(rootViewController: containerViewController), animated: true)
    }
    
    @objc private func didToggleSetting() {
        let containerViewController = SettingViewController()
        present(UINavigationController(rootViewController: containerViewController), animated: true)
    }
}

extension BookmarkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        setNeedsReload()
    }
}

extension BookmarkViewController: UICollectionViewDataSource {
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
            sectionHeader.title.text = "Pinned"
        } else {
            sectionHeader.title.text = "Collected"
        }
        
        return sectionHeader
    }
}

extension BookmarkViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(CollectionViewController(), animated: true)
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
