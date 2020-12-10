//
//  PlayLoop.swift
//  Teleport
//
//  Created by Eric Internicola on 12/10/20.
//

import Foundation
import SwiftUI

/// Simply a toggle for tracking if we should be looping or not.
/// Note that the `text` property does not reflect the current state, but the action
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

    var actionText: some View {
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

