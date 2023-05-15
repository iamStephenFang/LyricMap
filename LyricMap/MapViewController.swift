//
//  MapViewController.swift
//  LyricMap
//
//  Created by StephenFang on 2023/5/11.
//

import UIKit
import MapKit

import SnapKit


class MapViewController: UIViewController {
    
    fileprivate var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
    }
    
    private func setupMapView() {
        mapView = MKMapView(frame: view.bounds)
        mapView.delegate = self
        
        // Setup map view
        mapView.mapType = .standard
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsScale = false
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
