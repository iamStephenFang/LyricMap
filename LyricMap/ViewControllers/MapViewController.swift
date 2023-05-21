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


class MapViewController: BaseViewController {
    
    fileprivate var mapView: MKMapView!
    
    fileprivate var userLocationButton: UIButton!
    fileprivate var realityButton: UIButton!
    
    fileprivate let locationManager = CLLocationManager()
    private let regionInMeters: Double = 10000
    
    private var places: [LyricPlace] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "LyricMap")

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
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsScale = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.showsUserLocation = true
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        places.append(LyricPlace(lyricInfo: LyricInfo(songName: "弥敦道",
                                                      albumName: "Go!",
                                                      albumImageUrl: "https://www.kkbox.com/hk/tc/album/GlnoJGUQs-18ALK203",
                                                      artistName: "洪卓立",
                                                      highlightedLyrics: [""],
                                                      highlightedPosition: 1000),
                                 locationName: "弥敦道",
                                 coordinate: CLLocationCoordinate2D(latitude: 22.316200, longitude: 114.170233)))
        mapView.addAnnotations(places)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func setupSidePanel() {
        userLocationButton = UIButton(type: .system)
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .small
        config.image = UIImage(systemName: "location.fill")
        userLocationButton.configuration = config
        userLocationButton.addTarget(self, action: #selector(recenterUserLocation), for: .touchUpInside)
        view.addSubview(userLocationButton)
        userLocationButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-UIDefine.horizontalMargin)
            make.height.equalTo(UIDefine.buttonSize)
            make.width.equalTo(UIDefine.buttonSize)
        }
        
        realityButton = UIButton(type: .system)
        var arConfig = UIButton.Configuration.gray()
        arConfig.cornerStyle = .small
        arConfig.image = UIImage(systemName: "cube.transparent")
        realityButton.configuration = arConfig
        realityButton.addTarget(self, action: #selector(presentRealityView), for: .touchUpInside)
        view.addSubview(realityButton)
        realityButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.right.equalToSuperview().offset(-UIDefine.horizontalMargin)
            make.height.equalTo(UIDefine.buttonSize)
            make.width.equalTo(UIDefine.buttonSize)
        }
    }
    
    // MARK: Locations
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
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
    
    @objc private func presentRealityView() {
        present(ARLyricViewController(), animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let place = annotation as? LyricPlace else {
            return nil
        }
        
        var view: MKAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "LyricMarkerView") as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = LyricMarkerView(annotation: annotation, reuseIdentifier: "LyricMarkerView")
            if let customAnnotationView = view as? LyricMarkerView {
                let imageView = customAnnotationView.subviews.first as? UIImageView
                print(place.lyricInfo.albumImageUrl)
                imageView?.sd_setImage(with: URL(string: place.lyricInfo.albumImageUrl))
            }
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            view.sd_setImage(with: URL(string: place.lyricInfo.albumImageUrl))
        }
        return view
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let place = view.annotation as? LyricPlace else {
            return
        }
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
        ]
        place.mapItem?.openInMaps(launchOptions: launchOptions)
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
            title: "Failed to get location",
            subtitle: "Please check internet connection"
        )
        toast.show()
    }
}
