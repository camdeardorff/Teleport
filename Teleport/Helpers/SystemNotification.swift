//
//  SystemNotification.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/8/20.
//

import CoreLocation
import Foundation

fileprivate extension Notification.Name {
    static let SimulateLocation = Notification.Name(rawValue: "com.apple.iphonesimulator.simulateLocation")
}


struct SystemNotification {

    func simulate(coordinates: CLLocationCoordinate2D, to simulators: [String]) {
        let info: [AnyHashable: Any] = [
            "simulateLocationLatitude": coordinates.latitude,
            "simulateLocationLongitude": coordinates.longitude,
            "simulateLocationDevices": simulators,
        ]

        let notification = Notification(
            name: Notification.Name.SimulateLocation,
            object: nil,
            userInfo: info)

        DistributedNotificationCenter.default().post(notification)
    }

}
