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
    
    var body: some View {
        
        HStack {

            Button(action: {
                speed = speed.next
            }) {
                speed.text
                    .font(.headline)
                    .padding(.all, 8)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            
            switch state {
            case .stopped:
                Button(action: {
                    state = .playing
                }) {
                    PlayState.playing.view
                }
                .buttonStyle(BorderlessButtonStyle())
            case .playing:
                Button(action: {
                    state = .paused
                }) {
                    PlayState.paused.view
                }
                .buttonStyle(BorderlessButtonStyle())
                
            case .paused:
                Button(action: {
                    state = .stopped
                }) {
                    PlayState.stopped.view
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    state = .playing
                }) {
                    PlayState.playing.view
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

struct PlayBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationDetail_PreviewProvider.previews
            PlayBar(state: .constant(.stopped), speed: .constant(.fast))
            PlayBar(state: .constant(.playing), speed: .constant(.regular))
            PlayBar(state: .constant(.paused), speed: .constant(.slow))
            PlayBar(state: .constant(.paused), speed: .constant(.slow))
            
        }
    }
}
