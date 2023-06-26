//
//  NearbyPlacesViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import UIKit
import CoreLocation
import Toast


class NearbyPlacesViewController: UIViewController {
    
    fileprivate var collectionView: UICollectionView!
    fileprivate let locationManager = CLLocationManager()
    
    private var lyricInfos: [LyricInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if let location = locationManager.location?.coordinate {
            lyricInfos = findNearestLyricInfos(infos: LyricInfoManager.infos, userLocation: location)
        }
        
        setupBlurView()
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    private func setupBlurView() {
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
    }
    
    private func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 4, bottom: 0, trailing: 4)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(400))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(section: layoutSection, configuration: config)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
    
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    // MARK: Locations
    
    func findNearestLyricInfos(infos: [LyricInfo], userLocation: CLLocationCoordinate2D) -> [LyricInfo] {
        var nearestLyricInfos: [LyricInfo] = []
        
        var distances = [CLLocationDistance: LyricInfo]()
        
        for info in infos {
            let distance = info.coordinate.distance(from: userLocation)
            distances[distance] = info
        }
        
        let sortedDistances = distances.keys.sorted()
         for i in 0..<5 {
             if let coordinate = distances[sortedDistances[i]] {
                 nearestLyricInfos.append(coordinate)
             }
         }
         
        return nearestLyricInfos
    }
    
    func findNearestLyricInfos(coordinates: [CLLocationCoordinate2D], userLocation: CLLocation) -> [CLLocationCoordinate2D] {
        var nearestCoordinates = [CLLocationCoordinate2D]()
        
        // 计算每个CLLocationCoordinate2D对象与当前用户位置的距离，并存储在字典中
        var distances = [CLLocationDistance: CLLocationCoordinate2D]()
        for coordinate in coordinates {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance = userLocation.distance(from: location)
            distances[distance] = coordinate
        }
        
        // 将字典按照距离进行排序，取出前五个最小距离的CLLocationCoordinate2D对象
        let sortedDistances = distances.keys.sorted()
        for i in 0..<5 {
            if let coordinate = distances[sortedDistances[i]] {
                nearestCoordinates.append(coordinate)
            }
        }
        
        return nearestCoordinates
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            let toast = Toast.default(
                image: UIImage(systemName: "location.slash")!,
                title: NSLocalizedString("map_failed_title", comment: ""),
                subtitle: NSLocalizedString("map_failed_subtitle", comment: "")
            )
            toast.show()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

extension NearbyPlacesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lyricInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseIdentifier, for: indexPath) as! DetailCollectionViewCell
        cell.configure(with: lyricInfos[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension NearbyPlacesViewController: UICollectionViewDelegate {
    
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

extension NearbyPlacesViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let toast = Toast.default(
            image: UIImage(systemName: "location.slash")!,
            title: NSLocalizedString("map_failed_title", comment: ""),
            subtitle: NSLocalizedString("map_failed_subtitle", comment: "")
        )
        toast.show()
    }
}
