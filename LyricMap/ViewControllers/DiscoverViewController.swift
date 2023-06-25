//
//  DiscoverViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/11.
//

import UIKit


class DiscoverViewController: BaseViewController {
    let sections = Bundle.main.decode([Section].self, from: "featuredlyrics.json")
    var collectionView: UICollectionView!

    var dataSource: UICollectionViewDiffableDataSource<Section, SectionItem>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: NSLocalizedString("discover_title", comment: ""))
        setNavigationRightBar(items:
                                [
                                    UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didToggleSetting))])
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.reuseIdentifier)
        collectionView.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: SongCollectionViewCell.reuseIdentifier)
        collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self

        createDataSource()
        reloadData()
    }

    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with item: SectionItem, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }

        cell.configure(with: item)
        return cell
    }

    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, SectionItem>(collectionView: collectionView) { collectionView, indexPath, app in
            switch self.sections[indexPath.section].type {
            case "playlist":
                return self.configure(SongCollectionViewCell.self, with: app, for: indexPath)
            case "collections":
                return self.configure(PlaylistCollectionViewCell.self, with: app, for: indexPath)
            default:
                return self.configure(FeaturedCollectionViewCell.self, with: app, for: indexPath)
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return nil
            }

            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            if section.title.isEmpty { return nil }

            sectionHeader.title.text = section.title
            sectionHeader.subtitle.text = section.subtitle
            return sectionHeader
        }
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource?.apply(snapshot)
    }

    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]

            switch section.type {
            case "playlist":
                return self.createMediumTableSection(using: section)
            case "collections":
                return self.createSmallTableSection(using: section)
            default:
                return self.createFeaturedSection(using: section)
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }

    func createFeaturedSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }

    func createMediumTableSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.33))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

        return layoutSection
    }

    func createSmallTableSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(200))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

        return layoutSection
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    // MARK: Actions
    
    @objc private func didToggleSetting() {
        let containerViewController = SettingViewController()
        present(UINavigationController(rootViewController: containerViewController), animated: true)
    }
}

extension DiscoverViewController: UICollectionViewDelegate {
  
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let item = collectionView.cellForItem(at: indexPath) else { return }
        let helper = ViewZoomHelper()
        helper.zoomOutWithView(view: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let item = collectionView.cellForItem(at: indexPath) else { return }
        let helper = ViewZoomHelper()
        helper.zoomInWithView(view: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section].type {
        case "playlist":
            break
        case "collections":
            if indexPath.item == 1 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.wanChaiList, title: sections[indexPath.section].items[indexPath.item].name), animated: true)
            } else if indexPath.item == 2 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.centralList, title: sections[indexPath.section].items[indexPath.item].name), animated: true)
            } else if indexPath.item == 3 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.shamShuiPoList, title: sections[indexPath.section].items[indexPath.item].name), animated: true)
            } else if indexPath.item == 4 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.yauTsimMongList, title: sections[indexPath.section].items[indexPath.item].name), animated: true)
            } else {
                navigationController?.pushViewController(CollectionViewController(), animated: true)
            }
        case "featured":
            if indexPath.item == 0 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.wanChaiList, title: sections[indexPath.section].items[indexPath.item].name), animated: true)
            } else if indexPath.item == 1 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.centralList, title: sections[indexPath.section].items[indexPath.item].name), animated: true)
            } else if indexPath.item == 2 {
                navigationController?.pushViewController(CollectionViewController(LyricInfoManager.shamShuiPoList, title: sections[indexPath.section].items[indexPath.item].name), animated: true)
            } else {
                navigationController?.pushViewController(CollectionViewController(), animated: true)
            }
        default:
            break
        }
    }
}
