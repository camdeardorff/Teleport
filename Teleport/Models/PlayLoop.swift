//
//  PlayLoop.swift
//  Teleport
//
//  Created by Eric Internicola on 12/10/20.
//

import Foundation
import SwiftUI

// associated value corresponds to the delay between location changes.
// this should be changed such that it is a measure of distance covered
// over the course of the same period of time.
// would require interpolation of points.
enum PlayLoop: Double, CaseIterable {
    case loop
    case notLooped

    var toggle: PlayLoop {
        switch self {
        case .loop:
            return .notLooped
        case .notLooped:
            return .loop
        }
    }

    var text: some View {
        var t: Text
        switch self {
        case .loop:
            t = Text("↩️")
        case .notLooped:
            t = Text("🔄")
        }
        return t
    }
}

