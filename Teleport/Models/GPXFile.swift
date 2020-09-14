//
//  GPXFile.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/3/20.
//

import Foundation
import CoreLocation
import CoreGPX

struct GPXFile: Hashable, PathProvider {
    var name: String
    var url: URL
    var title: String?
    var description: String?
    var path: [CLLocation]
}

let files: [GPXFile] = [
    "bros.gpx",
    "hood.gpx",
    "rain.gpx",
    "long.gpx",
    "whitney.gpx"
].map {
    let components = $0.split(separator: ".")
    guard let filename = components.first,
          let fileext = components.last,
          let stringPath = Bundle.main.path(forResource: String(filename), ofType: String(fileext)),
          let parser = GPXParser(withURL: URL(fileURLWithPath: stringPath)),
          let data = parser.parsedData() else { fatalError() }
    
    return GPXFile(
        name: $0,
        url: URL(fileURLWithPath: stringPath),
        title: data.deepName,
        description: data.deepDescription,
        path: data.path)
}

let debugPaths: [PathSimulationProvider] = files.map {
    PathSimulationProvider(
        pathProvider: $0,
        duration: 360,
        interpolate: false,
        pathType: PathType.bestGuess(for: $0.path) ?? .outAndBack)
}
