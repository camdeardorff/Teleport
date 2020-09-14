//
//  SimulatorController.swift
//  Teleport
//
//  Created by Cameron Deardorff on 9/12/20.
//

import Foundation
import Combine

class SimulatorController: ObservableObject {
    
    static var shared: SimulatorController = SimulatorController()
    
    let publisher = PassthroughSubject<[Simulator], Never>()
    
    private let simulatorUpdateFrequency: TimeInterval = 10
    
    private init() {
        let timer = Timer.scheduledTimer(withTimeInterval: simulatorUpdateFrequency, repeats: true) { [weak self] _ in
            DispatchQueue.global(qos: .utility).async { [weak self] in
                do {
                    guard let strongSelf = self else { return }
                    let sims = try strongSelf.fetch().bootedSimulators
                    strongSelf.publisher.send(sims)
                } catch let e {
                    print("failed to update simulators - \(e)")
                }
            }
        }
        timer.tolerance = 1/simulatorUpdateFrequency
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        timer.fire()
    }
    
    private func fetch() throws -> Simulators {
        let task = Process()
        task.launchPath = "/usr/bin/xcrun"
        task.arguments = ["simctl", "list", "-j", "devices"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()
        pipe.fileHandleForReading.closeFile()
        
        if task.terminationStatus != 0 {
            throw SimulatorFetchError.simctlFailed
        }
        
        do {
            return try JSONDecoder().decode(Simulators.self, from: data)
        } catch {
            throw SimulatorFetchError.decodeFailed
        }
    }
}


enum SimulatorFetchError: Error {
    case simctlFailed
    case decodeFailed
    
    var description: String {
        switch self {
        case .simctlFailed:
            return "Running `simctl list` failed"
        case .decodeFailed:
            return "Failed to read output from simctl"
        }
    }
}

