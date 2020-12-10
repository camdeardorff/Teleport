//
//  PlayBar.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/1/20.
//

import SwiftUI

struct PlayBar: View {
    @Binding var state: PlayState
    @Binding var speed: PlaySpeed
    @Binding var loop: PlayLoop

    var body: some View {
        HStack {
            Button(action: {
                self.speed = self.speed.next
            }) {
                speed.text
                    .font(.headline)
                    .padding(.all, 8)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            currentButton
            Button(action: {
                self.loop = self.loop.toggle
            }) {
                loop.text
                    .font(.headline)
                    .padding(.all, 8)
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}

// MARK: - Implementation

extension PlayBar {

    var stoppedButton: some View {
        Button(action: {
            self.state = .playing
        }) {
            PlayState.playing.view
        }
        .buttonStyle(BorderlessButtonStyle())
    }

    var playButton: some View {
        Button(action: {
            self.state = .paused
        }) {
            PlayState.paused.view
        }
        .buttonStyle(BorderlessButtonStyle())
    }

    var pauseButton: some View {
        HStack {
            Button(action: {
                self.state = .stopped
            }) {
                PlayState.stopped.view
            }
            .buttonStyle(BorderlessButtonStyle())

            Button(action: {
                self.state = .playing
            }) {
                PlayState.playing.view
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }

    var currentButton: AnyView {
        switch state {
        case .stopped:
            return AnyView(stoppedButton)
        case .playing:
            return AnyView(playButton)
        case .paused:
            return AnyView(pauseButton)
        }
    }

}

struct PlayBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationDetail_PreviewProvider.previews
            PlayBar(state: .constant(.stopped), speed: .constant(.fast), loop: .constant(.loop))
            PlayBar(state: .constant(.playing), speed: .constant(.regular), loop: .constant(.notLooped))
            PlayBar(state: .constant(.paused), speed: .constant(.slow), loop: .constant(.loop))
            PlayBar(state: .constant(.paused), speed: .constant(.slow), loop: .constant(.notLooped))
        }
    }
}
