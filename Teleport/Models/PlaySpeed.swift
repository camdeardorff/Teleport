//
//  PlaySpeed.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/27/20.
//

import Foundation
import SwiftUI

// associated value corresponds to the delay between location changes.
// this should be changed such that it is a measure of distance covered
// over the course of the same period of time.
// would require interpolation of points.
enum PlaySpeed: Double, CaseIterable {
    case slow = 3
    case regular = 2
    case fast = 1
    
    var next: PlaySpeed {
        switch self {
        case .slow: return .regular
        case .regular: return .fast
        case .fast: return .slow
        }
    }
    var text: some View {
        var t: Text
        switch self {
        case .slow: t = Text("1x")
        case .regular: t = Text("2x")
        case .fast: t = Text("3x")
        }
        return t
    }
}
