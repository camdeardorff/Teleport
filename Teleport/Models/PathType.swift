//
//  GPSPathRepresentable.swift
//  Teleport
//
//  Created by Cameron Deardorff on 6/29/20.
//

import Foundation
import CoreLocation

enum PathType: String, Codable {
    case outAndBack
    case loop
    case pointToPoint
    
    var distanceMultiplier: Int {
        switch self {
        case .outAndBack: return 2
        case .loop, .pointToPoint: return 1
        }
    }
    var displayString: String {
        switch self {
        case .outAndBack: return "Out and Back"
        case .loop: return "Loop"
        case .pointToPoint: return "Point to Point"
        }
    }
    static func bestGuess(for path: [CLLocation]) -> PathType? {
        guard !path.isEmpty else { return nil }
        guard let start = path.first,
              let end = path.last
        else { return nil }
        
        /**
            there are a bunch of heuristics that could be checked here but for now I am going to leave this really dumb
            one could pick the midpoint of a path and see if the latter end of the midpoint matches up nicely with the former... for each latter point see if there is a midpoint within 50 meters. maybe a 75% rate would work nicely.
            looking at the elevation profile could also provide helpful
         */
        
        if end.distance(from: start) < 100 {
            return .loop
        }
        return .outAndBack
    }
}
