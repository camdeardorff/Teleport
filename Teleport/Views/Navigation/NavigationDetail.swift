//
//  NavigationDetail.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/1/20.
//

import SwiftUI

struct NavigationDetail: View {
    
    var path: PathSimulationProvider
    @ObservedObject private var player: PathSimulationPlayer
    
    var body: some View {
        VStack(spacing: 0) {
            MapView(
                path: player.path,
                currentLocation: $player.currentLocation,
                speed: $player.speed)
            Divider()
            PlayBar(
                state: $player.state,
                speed: $player.speed)
        }
        .frame(minWidth: 500, minHeight: 400)
        .onDisappear {
            self.player.state = .stopped
        }
    }
    
    init(path p: PathSimulationProvider) {
        path = p
        player = PathSimulationPlayer(provider: path)
    }
    
}

struct NavigationDetail_PreviewProvider: PreviewProvider {
    static var previews: some View {
        return NavigationDetail(path: debugPaths[0])
    }
}
