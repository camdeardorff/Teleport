//
//  PlayState.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/27/20.
//

import Foundation
import SwiftUI

enum PlayState {
    case playing
    case paused
    case stopped
    
    var image: Image {
        switch self {
        case .playing:
            return Image("play.fill")
        case .paused:
            return Image("pause.fill")
        case .stopped:
            return Image("stop.fill")
        }
    }
    var view: some View {
        image
            .resizable()
            .frame(width: 24, height: 24, alignment: .center)
            .padding(8)
    }
}
