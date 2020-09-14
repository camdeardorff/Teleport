//
//  MapView.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/1/20.
//

import SwiftUI
import MapKit

struct MapView {
    
    var path: [CLLocation]
    @Binding var currentLocation: CLLocation?
    @Binding var speed: PlaySpeed

    func makeMapView() -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.showsCompass = true
        map.showsZoomControls = true
        
        if let frame = CoordinateFrame(path: path, pathFrame: .trail) {
            let span = MKCoordinateSpan(
                latitudeDelta: frame.latitudeDistance,
                longitudeDelta: frame.longitudeDistance)
            let region = MKCoordinateRegion(
                center: frame.center,
                span: span)
            map.setRegion(region, animated: false)
        }
        
        let coords = path.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        map.removeOverlays(map.overlays)
        map.addOverlay(polyline)

        return map
    }
    
    func makeCoordinator() -> MapViewCoordinator {
         MapViewCoordinator(self)
    }
    
    func updateMapView(_ view: MKMapView, context: Context) {
        if view.delegate == nil {
            view.delegate = context.coordinator
        }
        
        if currentLocation != nil {
            let annotation = view.annotations.first as? MKUserLocation ?? MKUserLocation()
            NSAnimationContext.runAnimationGroup { (context) in
                context.duration = speed.rawValue
                context.allowsImplicitAnimation = true
                // shhhh! nothing to see here. 
                annotation.setValue(currentLocation!.coordinate, forKey: "coordinate")
            }
            
            if view.annotations.isEmpty {
                view.addAnnotation(annotation)
            }
        }
    }
}

extension MapView: NSViewRepresentable {
    func makeNSView(context: Context) -> MKMapView {
        makeMapView()
    }
    
    func updateNSView(_ nsView: MKMapView, context: Context) {
        updateMapView(nsView, context: context)
    }
    
    static func dismantleNSView(_ nsView: MKMapView, coordinator: Self.Coordinator) {
        nsView.removeOverlays(nsView.overlays)
        nsView.removeAnnotations(nsView.annotations)
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let path = [CLLocation(latitude: 38.9982, longitude: -106.3748), CLLocation(latitude: 38.9888, longitude: -106.3778), CLLocation(latitude: 38.9717, longitude: -106.3716), CLLocation(latitude: 38.9582, longitude: -106.3578)]
        return MapView(path: path, currentLocation: .constant(nil), speed: .constant(.regular))
    }
}
