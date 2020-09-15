//
//  FileRow.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/1/20.
//

import SwiftUI

struct PathRow: View {
    var path: PathSimulationProvider
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(path.title)
                .fontWeight(.bold)
            if path.title != path.name {
                Text(path.name)
                    .font(.caption)
                    .opacity(0.9)
            }
            Text(path.description)
                .font(.caption)
                .opacity(0.625)
        }
        .padding(.vertical, 4)
    }
}


struct FileRow_Previews: PreviewProvider {
    static var previews: some View {
        PathRow(path: debugPaths[0])
    }
}
