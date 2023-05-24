//
//  LyricMapWidget.swift
//  LyricMapWidget
//
//  Created by StephenFang on 2023/5/24.
//

import WidgetKit
import SwiftUI
import MapKit

struct Provider: TimelineProvider {
    fileprivate let locationManager = CLLocationManager()
    private let regionInMeters: Double = 12000
    
    private var infos = [
        LyricInfo(songInfo: SongInfo(songName: "彌敦道", albumName: "Go!", albumImageUrl: "https://www.kkbox.com/hk/tc/album/GlnoJGUQs-18ALK203", artistName: "洪卓立"), content: "彌敦道", locationName: "彌敦道", coordinate: CLLocationCoordinate2D(latitude: 22.316200, longitude: 114.170233)),
        LyricInfo(songInfo: SongInfo(songName: "中環", albumName: "阿田", albumImageUrl: "https://i.kfs.io/album/global/5654587,2v1/fit/500x500.jpg", artistName: "側田"), content: "任你為了他追隨 仍停滯到中區", locationName: "中環", coordinate: CLLocationCoordinate2D(latitude: 22.281507, longitude: 114.159111)),
        LyricInfo(songInfo: SongInfo(songName: "皇后大道東", albumName: "羅大佑自選輯", albumImageUrl: "https://i.kfs.io/album/tw/33279,1v1/fit/500x500.jpg", artistName: "羅大佑"), content: "皇后大道東上為何無皇宫", locationName: "皇后大道", coordinate: CLLocationCoordinate2D(latitude: 22.276037, longitude: 114.170211))
    ]
    
    func placeholder(in context: Context) -> MapEntry {
        MapEntry(date: Date(), image: UIImage(systemName: "location")!)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MapEntry) -> ()) {
        let mapSnapshotter = makeSnapshotter(
            with: context.displaySize)
        mapSnapshotter.start { (snapshot, error) in
            if let snapshot = snapshot {
                completion(MapEntry(date: Date(),
                                    image: snapshot.image))
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let mapSnapshotter = makeSnapshotter(
            with: context.displaySize)
        mapSnapshotter.start { (snapshot, error) in
            if let snapshot = snapshot {
                
                DispatchQueue.main.async {
                    UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                    snapshot.image.draw(at: .zero)
                    
                    for annotation in infos {
                        let point = snapshot.point(for: annotation.coordinate)
                        let image = UIImage(named: annotation.songInfo.songName)
                        let resizedImage = image?.imageWithSize(size: CGSize(width: 30, height: 30))
                        let roundedImage = resizedImage?.imageWithRoundedCorners(radius: 5)
                        roundedImage?.draw(in: CGRect(x: point.x, y: point.y, width: 30, height: 30))
                    }
                    
                    let date = Date()
                    let nextUpdate = Calendar.current.date(byAdding: .minute,
                                                           value: 10,
                                                           to: date)!
                    let entry = MapEntry(date: date,
                                         image: UIGraphicsGetImageFromCurrentImageContext()!)
                    UIGraphicsEndImageContext()
                    
                    let timeline = Timeline(entries: [entry],
                                            policy: .after(nextUpdate))
                    completion(timeline)
                }
            }
        }
    }
    
    private func makeSnapshotter(with size: CGSize)
    -> MKMapSnapshotter {
        let options = MKMapSnapshotter.Options()
        options.size = size
        options.showsBuildings = true
        options.pointOfInterestFilter = .excludingAll
        options.mapType = .standard
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            options.region = region
        }
        
        return MKMapSnapshotter(options: options)
    }
}

struct MapEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct LyricMapWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(uiImage: entry.image)
    }
}

struct LyricMapWidget: Widget {
    let kind: String = "LyricMapWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LyricMapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nearby Lyrics")
        .description("A quick glance at the lyrics of any songs mentioned nearby")
    }
}
