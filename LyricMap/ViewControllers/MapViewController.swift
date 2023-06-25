//
//  MapViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/11.
//

import UIKit
import MapKit

import SnapKit
import Toast
import SDWebImage


class MapViewController: BaseViewController {
    
    fileprivate var mapView: MKMapView!
    
    fileprivate var userLocationButton: ZoomButton!
    fileprivate var nearbyButton: ZoomButton!
    
    fileprivate let locationManager = CLLocationManager()
    private let regionInMeters: Double = 10000
    
    private var infos: [LyricInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infos = LyricInfoManager.infos
        
        setupMapView()
        setupSidePanel()
        checkLocationAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    private func setupMapView() {
        mapView = MKMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsBuildings = true
        mapView.showsTraffic = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsScale = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        mapView.addAnnotations(infos)
        mapView.showAnnotations(infos, animated: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func setupSidePanel() {
        let sidePanel = UIView()
        sidePanel.backgroundColor = .secondarySystemBackground
        sidePanel.layer.cornerRadius = 8.0
        sidePanel.layer.masksToBounds = false
        sidePanel.layer.shadowOffset = CGSize(width: 0, height: 4)
        sidePanel.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        sidePanel.layer.shadowOpacity = 1
        sidePanel.layer.shadowRadius = 8
        view.addSubview(sidePanel)
        sidePanel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-UIDefine.horizontalMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-UIDefine.buttonSize)
            make.height.equalTo(UIDefine.buttonSize * 2)
            make.width.equalTo(UIDefine.buttonSize)
        }
        
        let sidePanelLine = UIView()
        sidePanelLine.backgroundColor = UIColor.separator
        sidePanel.addSubview(sidePanelLine)
        sidePanelLine.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        userLocationButton = ZoomButton()
        userLocationButton.tintColor = UIColor(hexString: "5F8392")
        userLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        userLocationButton.addTarget(self, action: #selector(recenterUserLocation), for: .touchUpInside)
        sidePanel.addSubview(userLocationButton)
        userLocationButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIDefine.buttonSize)
        }
        
        nearbyButton = ZoomButton()
        nearbyButton.tintColor = UIColor(hexString: "5F8392")
        nearbyButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        nearbyButton.addTarget(self, action: #selector(presentNearbyPlaces), for: .touchUpInside)
        sidePanel.addSubview(nearbyButton)
        nearbyButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIDefine.buttonSize)
        }
    }
    
    // MARK: Locations
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
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
    
    // MARK: Actions
    
    @objc private func recenterUserLocation() {
        centerViewOnUserLocation()
    }
    
    @objc private func presentNearbyPlaces() {
        // Close all callout view first
        for annotation in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
        
        let containerViewController = NearbyPlacesViewController()
        if let sheet = containerViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet
                .prefersGrabberVisible = true
            sheet.preferredCornerRadius = UIDefine.sheetCornerRadius
        }
        self.present(containerViewController, animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LyricInfo else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "LyricMarkerView")
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "LyricMarkerView")
        annotationView?.canShowCallout = true
        annotationView?.detailCalloutAccessoryView = LyricCalloutView(lyricInfo: annotation)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.sd_setImage(with: URL(string: annotation.songInfo.albumImageUrl), placeholderImage: UIImage(named: "PlaceHolder"))
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        annotationView?.addSubview(imageView)
        annotationView?.frame = imageView.frame
        
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
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
