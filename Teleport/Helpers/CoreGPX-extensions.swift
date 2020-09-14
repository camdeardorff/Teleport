//
//  CoreGPX-extensions.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/3/20.
//

import Foundation
import CoreGPX

extension GPXRoot {
    var deepName: String? {
        return
            self.metadata?.name ??
            self.tracks.name ??
            self.routes.name
    }
    var deepDescription: String? {
        return
            self.metadata?.desc ??
            self.tracks.deepDesc ??
            self.routes.deepDesc
    }
    var path: [CLLocation] {
        var points: [CLLocation] = []
        if points.isEmpty {
            points = self.routes.toLocations()
        }
        if points.isEmpty {
            points = self.tracks.toLocations()
        }
        if points.isEmpty {
            points = self.waypoints.toLocations()
        }
        return points
    }
}


extension Array where Element: GPXRoute {
    func toLocations() -> [CLLocation] {
        return self
            // sort routes by their number
            .sorted { ($0.number ?? 0) < ($1.number ?? 0) }
            // turn routes into segments (use index for ordering)
            
            .map { route in
                route.routepoints
                    .compactMap { $0.toCLLocation() }
            }
            .flatMap { $0 }
    }
    var name: String? {
        return self
            .compactMap { $0.name }
            .first
    }
    var deepDesc: String? {
        return self
            .compactMap { $0.desc }
            .first
    }
}

extension Array where Element: GPXTrack {
    func toLocations() -> [CLLocation] {
        return self
            // sort the tracks by their number
            .sorted { ($0.number ?? 0) < ($1.number ?? 0) }
            // turn tracks into segments (use index for ordering)
            .map { track in
                // get points from segments joined
                return track.tracksegments
                    // TODO: is a sort needed here?
                    // join segment points
                    .flatMap { $0.trackpoints }
                    .compactMap { $0.toCLLocation() }
            }.flatMap { $0 }
    }
    var name: String? {
        return self
            .compactMap { $0.name }
            .first
    }
    var deepDesc: String? {
        return self
            .compactMap { $0.desc }
            .first
    }
}

extension Array where Element: GPXWaypoint {
    func toLocations() -> [CLLocation] {
        return self.compactMap { $0.toCLLocation() }
    }
}


extension GPXWaypoint {
    
    func toCLLocation() -> CLLocation? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocation(latitude: lat, longitude: lon)
    }
}

