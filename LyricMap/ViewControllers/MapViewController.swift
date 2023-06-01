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
    
    fileprivate var userLocationButton: UIButton!
    fileprivate var nearbyButton: UIButton!
    
    fileprivate let locationManager = CLLocationManager()
    private let regionInMeters: Double = 10000
    
    private var infos: [LyricInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        infos = [
            LyricInfo(songInfo: SongInfo(songName: "彌敦道", albumName: "Go!", albumImageUrl: "https://i.kfs.io/album/global/102905,2v1/fit/500x500.jpg", artistName: "洪卓立"), content: "彌敦道", locationName: "彌敦道", coordinate: CLLocationCoordinate2D(latitude: 22.316200, longitude: 114.170233)),
            LyricInfo(songInfo: SongInfo(songName: "中環", albumName: "阿田", albumImageUrl: "https://i.kfs.io/album/global/5654587,2v1/fit/500x500.jpg", artistName: "側田"), content: "任你為了他追隨 仍停滯到中區", locationName: "中環", coordinate: CLLocationCoordinate2D(latitude: 22.281507, longitude: 114.159111)),
            LyricInfo(songInfo: SongInfo(songName: "皇后大道東", albumName: "羅大佑自選輯", albumImageUrl: "https://i.kfs.io/album/tw/33279,1v1/fit/500x500.jpg", artistName: "羅大佑"), content: "皇后大道東上為何無皇宫", locationName: "皇后大道", coordinate: CLLocationCoordinate2D(latitude: 22.276037, longitude: 114.170211)),
            LyricInfo(songInfo: SongInfo(songName: "芬梨道上", albumName: "Unlimited", albumImageUrl: "https://i.kfs.io/album/global/83770,2v1/fit/500x500.jpg", artistName: "楊千嬅"), content: "這山頂何其矜貴 怎可給停留一世", locationName: "芬梨道上", coordinate: CLLocationCoordinate2D(latitude: 22.270383, longitude: 114.151611)),
            LyricInfo(songInfo: SongInfo(songName: "九龍公園游泳池", albumName: "香港是個大商場", albumImageUrl: "https://i.kfs.io/album/global/147603846,0v1/fit/500x500.jpg", artistName: "my little airport"), content: "我喜歡九龍公園游泳池，那裡我不再執著一些往事", locationName: "九龍公園", coordinate: CLLocationCoordinate2D(latitude: 22.300436, longitude: 114.169721)),
            LyricInfo(songInfo: SongInfo(songName: "睜開眼", albumName: "Easy", albumImageUrl: "https://i.kfs.io/album/global/321619,2v1/fit/500x500.jpg", artistName: "RubberBand"), content: "回望那獅子山還是會牽掛", locationName: "獅子山", coordinate: CLLocationCoordinate2D(latitude: 22.352150, longitude: 114.184813)),
            LyricInfo(songInfo: SongInfo(songName: "流淚行勝利道", albumName: "新天地", albumImageUrl: "https://i.kfs.io/album/global/3966466,0v1/fit/500x500.jpg", artistName: "許志安"), content: "流淚行勝利道，別再做愛情奴", locationName: "勝利道", coordinate: CLLocationCoordinate2D(latitude: 22.319096, longitude: 114.174676)),
            LyricInfo(songInfo: SongInfo(songName: "時代廣場", albumName: "新天地", albumImageUrl: "https://i.kfs.io/album/global/3966466,0v1/fit/500x500.jpg", artistName: "許志安"), content: "誰站在大屏幕之下心碎痛哭，誰又悄悄往大鐘一邊嘆氣不想倒數", locationName: "時代廣場", coordinate: CLLocationCoordinate2D(latitude: 22.278306, longitude: 114.182146)),
            LyricInfo(songInfo: SongInfo(songName: "黃金時代", albumName: "我的快樂時代", albumImageUrl: "https://i.kfs.io/album/global/137522,0v1/fit/500x500.jpg", artistName: "陳奕迅"), content: "黃金廣場內分手，在時代門外再聚", locationName: "黃金廣場", coordinate: CLLocationCoordinate2D(latitude: 22.279951, longitude: 114.184306)),
            LyricInfo(songInfo: SongInfo(songName: "油尖旺金毛玲", albumName: "油尖旺金毛玲", albumImageUrl: "https://i.kfs.io/album/hk/19038407,1v1/fit/500x500.jpg", artistName: "Serrini"), content: "偷偷唱著這曲幻想他聽見，學下吉他中環賣唱太痴纏", locationName: "中環", coordinate: CLLocationCoordinate2D(latitude: 22.281507, longitude: 114.159111)),
            LyricInfo(songInfo: SongInfo(songName: "山旮旯", albumName: "山旮旯", albumImageUrl: "https://i.kfs.io/album/global/55099662,3v1/fit/500x500.jpg", artistName: "馮允謙"), content: "深水灣，淺水灣，獅子山，你以為定會等", locationName: "深水灣", coordinate: CLLocationCoordinate2D(latitude: 22.240259, longitude: 114.182005)),
            LyricInfo(songInfo: SongInfo(songName: "山旮旯", albumName: "山旮旯", albumImageUrl: "https://i.kfs.io/album/global/55099662,3v1/fit/500x500.jpg", artistName: "馮允謙"), content: "深水灣，淺水灣，獅子山，你以為定會等", locationName: "淺水灣", coordinate: CLLocationCoordinate2D(latitude: 22.234720, longitude: 114.193811)),
            LyricInfo(songInfo: SongInfo(songName: "山旮旯", albumName: "山旮旯", albumImageUrl: "https://i.kfs.io/album/global/55099662,3v1/fit/500x500.jpg", artistName: "馮允謙"), content: "深水灣，淺水灣，獅子山，你以為定會等", locationName: "獅子山", coordinate: CLLocationCoordinate2D(latitude: 22.352150, longitude: 114.184813)),
            LyricInfo(songInfo: SongInfo(songName: "眼紅館", albumName: "代表作", albumImageUrl: "https://i.kfs.io/album/global/326858,1v1/fit/500x500.jpg", artistName: "關智斌"), content: "我信你也紅著眼 寂寞便在紅館中一起搜索", locationName: "紅館", coordinate: CLLocationCoordinate2D(latitude: 22.301356, longitude: 114.182056)),
            LyricInfo(songInfo: SongInfo(songName: "山林道", albumName: "山林道", albumImageUrl: "https://i.kfs.io/album/global/13335437,1v1/fit/500x500.jpg", artistName: "謝安琪 (Kay Tse)"), content: "叢林萬里 別攔著我 舊時熱情又急躁 不看地圖", locationName: "山林道", coordinate: CLLocationCoordinate2D(latitude: 22.302711, longitude: 114.172679)),
            LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "再下個車站 到天后 當然最好", locationName: "天后", coordinate: CLLocationCoordinate2D(latitude: 22.282406, longitude: 114.192012)),
            LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "再下個車站 到天后 當然最好", locationName: "天后", coordinate: CLLocationCoordinate2D(latitude: 22.282406, longitude: 114.192012)),
            LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "在百德新街的愛侶 面上有種顧盼自豪", locationName: "百德新街", coordinate: CLLocationCoordinate2D(latitude: 22.281172, longitude: 114.185402)),
            LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "站在大丸前 細心看看我的路", locationName: "大丸百货（已結業）", coordinate: CLLocationCoordinate2D(latitude: 22.280651, longitude: 114.185273)),
            LyricInfo(songInfo: SongInfo(songName: "囍帖街", albumName: "Binary", albumImageUrl: "https://i.kfs.io/album/global/136893,0v1/fit/500x500.jpg", artistName: "謝安琪"), content: "就似這一區 曾經稱得上 美滿甲天下", locationName: "囍帖街（利東街）", coordinate: CLLocationCoordinate2D(latitude: 22.275466, longitude: 114.172164)),
        ]
        
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
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "LyricMarkerView")
            annotationView?.canShowCallout = true
            annotationView?.detailCalloutAccessoryView = LyricCalloutView(lyricInfo: annotation)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.sd_setImage(with: URL(string: annotation.songInfo.albumImageUrl), placeholderImage: UIImage(named: "PlaceHolder"))
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true
            annotationView?.addSubview(imageView)
            annotationView?.frame = imageView.frame
        } else {
            annotationView?.annotation = annotation
        }
        
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
