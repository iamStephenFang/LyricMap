//
//  CollectionViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/21.
//

import UIKit
import MapKit
import Toast

enum CollectionViewControllerInfo {
    static let mapHeight = CGFloat(200)
    static let regionInMeters = Double(5000)
}


class CollectionViewController: BaseViewController {
    
    fileprivate var infos = LyricInfoManager.infos
    
    var navTitle: String = "Collection"
    
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var tableView: UITableView!
    fileprivate var mapView: MKMapView!
    

    convenience init(_ infos: [LyricInfo], title: String) {
        self.init()
        
        self.infos = infos
        self.navTitle = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: navTitle)
        setNavigationRightBar(item: UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCollection)))
        navigationItem.largeTitleDisplayMode = .never
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: CollectionViewControllerInfo.mapHeight + CGFloat(infos.count) * UIDefine.cellHeight)
        view.addSubview(scrollView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: CollectionViewControllerInfo.mapHeight, width: view.bounds.size.width, height: CGFloat(infos.count) * UIDefine.cellHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UIDefine.cellHeight
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        scrollView.addSubview(tableView)
        tableView.register(SongInfoTableViewCell.self, forCellReuseIdentifier: SongInfoTableViewCell.reuseIdentifier)
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:CollectionViewControllerInfo.mapHeight))
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsScale = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.showsUserLocation = false
        scrollView.addSubview(mapView)
        
        mapView.addAnnotations(infos)
        mapView.showAnnotations(infos, animated: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()
    }
    
    @objc func editCollection() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: Locations
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: CollectionViewControllerInfo.regionInMeters, longitudinalMeters: CollectionViewControllerInfo.regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            let toast = Toast.default(
                image: UIImage(systemName: "location.slash")!,
                title: "Failed to get location",
                subtitle: "Please check location permissions"
            )
            toast.show()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
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

extension CollectionViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CollectionViewControllerInfo.regionInMeters, longitudinalMeters: CollectionViewControllerInfo.regionInMeters)
            mapView.setRegion(region, animated: true)
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

extension CollectionViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LyricInfo else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "LyricMarkerView")
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "LyricMarkerView")
        annotationView?.canShowCallout = true
        annotationView?.detailCalloutAccessoryView = LyricInfoView(lyricInfo: annotation)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.sd_setImage(with: URL(string: annotation.songInfo.albumImageUrl), placeholderImage: UIImage(named: "PlaceHolder"))
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        annotationView?.addSubview(imageView)
        annotationView?.frame = imageView.frame
        
        return annotationView
    }
}
