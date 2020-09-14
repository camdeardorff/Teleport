//
//  CoordinateFrame.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/1/20.
//

import Foundation
import CoreLocation

public enum PathCoordinateFrame: String, Codable {
    case trail
    case peak
}

public struct CoordinateFrame {
    
    public var southWestCorner: CLLocation
    public var northEastCorner: CLLocation
    
    public init?(southWestCorner: CLLocation, northEastCorner: CLLocation) {
        
        guard CLLocationCoordinate2DIsValid(southWestCorner.coordinate) else { return nil } // southWestCorner coordinates are invalid.
        guard CLLocationCoordinate2DIsValid(northEastCorner.coordinate) else { return nil } // northEastCorner coordinates are invalid.
        guard southWestCorner.coordinate.latitude < northEastCorner.coordinate.latitude else { return nil } // southWestCorner must be South of northEastCorner
        guard southWestCorner.coordinate.longitude < northEastCorner.coordinate.longitude else { return nil } // southWestCorner must be West of northEastCorner
        
        
        self.southWestCorner = southWestCorner
        self.northEastCorner = northEastCorner
    }
    
    public init?(minLat: CLLocationDegrees, maxLat: CLLocationDegrees, minLon: CLLocationDegrees, maxLon: CLLocationDegrees) {
        self.init(southWestCorner: CLLocation(latitude: minLat, longitude: minLon),
                  northEastCorner: CLLocation(latitude: maxLat, longitude: maxLon))
    }
    public init?(minPoint: CLLocationCoordinate2D, maxPoint: CLLocationCoordinate2D) {
        self.init(southWestCorner: CLLocation(latitude: minPoint.latitude, longitude: minPoint.longitude),
                  northEastCorner: CLLocation(latitude: minPoint.latitude, longitude: minPoint.longitude))
    }
    
    public init?(path: [CLLocation], pathFrame: PathCoordinateFrame) {
        guard !path.isEmpty else { return nil }
        switch pathFrame {
        case .trail:
            guard let frame = CoordinateFrame.trailFraming(for: path) else { return nil }
            southWestCorner = frame.southWestCorner
            northEastCorner = frame.northEastCorner
        case .peak:
            guard let frame = CoordinateFrame.peakFraming(for: path) else { return nil }
            southWestCorner = frame.southWestCorner
            northEastCorner = frame.northEastCorner
        }
    }
    
    public var center: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: (southWestCorner.coordinate.latitude + northEastCorner.coordinate.latitude) / 2.0,
            longitude: (southWestCorner.coordinate.longitude + northEastCorner.coordinate.longitude) / 2.0)
    }
    
    public var latitudeDistance: Double {
        return northEastCorner.coordinate.latitude - southWestCorner.coordinate.latitude
    }
    public var longitudeDistance: Double {
        return northEastCorner.coordinate.longitude - southWestCorner.coordinate.longitude
    }
    

    public func contains(point: CLLocationCoordinate2D) -> Bool {
        return southWestCorner.coordinate.latitude < point.latitude && point.latitude < northEastCorner.coordinate.latitude
            && southWestCorner.coordinate.longitude < point.longitude && point.longitude < northEastCorner.coordinate.latitude
    }
}

fileprivate extension CoordinateFrame {
    
    /**
     * Creates a frame that encompases `path` and adds padding with `paddingMultiplier`
     */
    private static func trailFraming(for path: [CLLocation], paddingMultiplier: Double = 0.4) -> CoordinateFrame? {
        
        let lats = path.map { $0.coordinate.latitude }
        let latPadding = (lats.max()! - lats.min()!) * paddingMultiplier
        let lons = path.map { $0.coordinate.longitude }
        let lonPadding = (lons.max()! - lons.min()!) * paddingMultiplier
        
        let newMinLat = lats.min()! - latPadding
        let newMaxLat = lats.max()! + latPadding
        let newMinLon = lons.min()! - lonPadding
        let newMaxLon = lons.max()! + lonPadding
        
        let northEastCorner = CLLocation(latitude: newMaxLat, longitude: newMaxLon)
        let southWestCorner = CLLocation(latitude: newMinLat, longitude: newMinLon)
        
        let diagonalDistance = northEastCorner.distance(from: southWestCorner)
        if diagonalDistance < 1_000 {
            return trailFraming(for: path, paddingMultiplier: paddingMultiplier + 0.2)
        } else {
            return CoordinateFrame(southWestCorner: southWestCorner, northEastCorner: northEastCorner)
        }
    }
    
    
    /**
     * Creates a frame centered on the highest point of `path`. The frame is padded with `paddingMultiplier`.
     */
    private static func peakFraming(for path: [CLLocation], paddingMultiplier: Double = 0.05) -> CoordinateFrame? {
        
        guard let lastPoint = path.last else { return nil }
        let highestPoint: CLLocation = path.reduce(lastPoint) { current, next in
            return next.altitude > current.altitude ? next : current
        }
        
        let greatestLatDistance: CLLocationDistance = path
            .map { $0.coordinate.latitude }
            .reduce(0.0) { current, next in
                let distance: Double = abs(highestPoint.coordinate.latitude - next)
                return max(distance, current)
        }
        
        let greatestLongDistance: CLLocationDistance = path
            .map { $0.coordinate.longitude }
            .reduce(0.0) { current, next in
                let distance: Double = abs(highestPoint.coordinate.longitude - next)
                return max(distance, current)
        }
        
        let framingDistance = max(greatestLatDistance, greatestLongDistance) * (1+paddingMultiplier)
        
        let northEast = CLLocation(
            latitude: highestPoint.coordinate.latitude + framingDistance,
            longitude: highestPoint.coordinate.longitude + framingDistance)
        
        let southWest = CLLocation(
            latitude: highestPoint.coordinate.latitude - framingDistance,
            longitude: highestPoint.coordinate.longitude - framingDistance)
        
        return CoordinateFrame(southWestCorner: southWest, northEastCorner: northEast)
    }
}

