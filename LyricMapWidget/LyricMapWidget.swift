//
//  LyricMapWidget.swift
//  LyricMapWidget
//
//  Created by StephenFang on 2023/5/24.
//

import WidgetKit
import SDWebImage
import SwiftUI
import MapKit

struct Provider: TimelineProvider {
    fileprivate let locationManager = CLLocationManager()
    private let regionInMeters: Double = 3000
    
    private var infos = LyricInfoManager.infos
    
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
                        SDWebImageManager.shared.loadImage(
                            with: URL(string: annotation.songInfo.albumImageUrl),
                            options: .continueInBackground,
                            progress: nil,
                            completed: { (image, data, error, cacheType, finished, url) in
                                let resizedImage = image?.imageWithSize(size: CGSize(width: 30, height: 30))
                                let roundedImage = resizedImage?.imageWithRoundedCorners(radius: 5)
                                roundedImage?.draw(in: CGRect(x: point.x, y: point.y, width: 30, height: 30))
                            }
                        )
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
