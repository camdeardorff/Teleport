//
//  LocationSimulationSession.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/4/20.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

class PathSimulationPlayer: ObservableObject {
        
    private var locationIndex: Int? = nil
    private var timer: RepeatingTimer? = nil
    
    @Published var speed: PlaySpeed = .fast {
        didSet {
            timer?.timeInterval = speed.rawValue
        }
    }
    
    @Published var state: PlayState = .stopped {
        didSet {
            if oldValue == .stopped && state == .playing {
                timer = RepeatingTimer(timeInterval: speed.rawValue)
                timer?.eventHandler = { [weak self] in
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        let idx = strongSelf.locationIndex ?? 0
                        
                        guard (0..<strongSelf.path.count).contains(idx) else {
                            strongSelf.timer = nil
                            strongSelf.state = .stopped
                            return
                        }
                        
                        strongSelf.currentLocation = strongSelf.path[idx]
                        strongSelf.locationIndex = (self?.locationIndex ?? 0) + 1
                    }
                }
                timer?.resume()
                return
            }
            if oldValue == .playing && state == .paused {
                timer?.suspend()
            }
            if oldValue == .paused && state == .playing {
                timer?.resume()
            }
            if state == .stopped {
                timer = nil
                currentLocation = nil
                locationIndex = nil
            }
        }
    }
    
    @Published var currentLocation: CLLocation? = nil {
        didSet {
            guard currentLocation != nil else { return }
            let sims = simulators.map { $0.udid.uuidString }
            SystemNotification().simulate(coordinates: currentLocation!.coordinate, to: sims)
        }
    }
    
    var provider: PathSimulationProvider
    var path: [CLLocation] { return provider.path }
    
    private var simulators: [Simulator] = []
    private weak var cancellable: AnyCancellable? = nil

    init(provider: PathSimulationProvider) {
        self.provider = provider
        self.cancellable = SimulatorController.shared.publisher
            .sink { (simulators) in
                self.simulators = simulators
            }
    }
}
