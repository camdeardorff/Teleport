//
//  Simulator.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/8/20.
//

import Foundation

struct Simulators: Codable {
    private let devices: [String: [Simulator]]

    var simulators: [Simulator] {
        return self.devices.flatMap { $1 }
    }
    var bootedSimulators: [Simulator] {
        return simulators.filter { $0.isBooted }
    }
}

struct Simulator: Codable {
    private let state: String
    fileprivate let name: String
    let udid: UUID

    var isBooted: Bool {
        return self.state == "Booted"
    }
}
