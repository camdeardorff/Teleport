//
//  ContentView.swift
//  Teleport
//
//  Created by Cameron Deardorff on 6/29/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView() {
            NavigationPrimary()
            VStack {
                Image(nsImage: NSImage(named: "gpx.png")!)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Select or add a path to simulate.")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x: 0, y: -70)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .frame(minWidth: 700, minHeight: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
