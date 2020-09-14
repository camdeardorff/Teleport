//
//  PathProvider.swift
//  Teleport
//
//  Created by Cameron Deardorff on 9/12/20.
//

import Foundation
import CoreLocation

protocol PathProvider {
    // file
    var name: String { get }
    var url: URL { get }
    var path: [CLLocation] { get }
    // metadata provided by the source file
    var title: String? { get }
    var description: String? { get }
}

struct PathSimulationProvider: Identifiable, Hashable {
    
    // given
    var pathProvider: PathProvider
    var duration: TimeInterval
    var interpolate: Bool
    var pathType: PathType

    // derived
    var id: UUID = UUID()
    var name: String { pathProvider.name }
    var path: [CLLocation] { pathProvider.path }
    var title: String { pathProvider.title ?? "" }
    var description: String { pathProvider.description ?? "" }
    
    static func == (lhs: PathSimulationProvider, rhs: PathSimulationProvider) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(interpolate)
        hasher.combine(pathType)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(path)
        hasher.combine(title)
        hasher.combine(description)
    }
}
