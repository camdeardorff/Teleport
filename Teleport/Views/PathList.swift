//
//  FileList.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/1/20.
//

import SwiftUI

struct PathList: View {
    @ObservedObject var pathsViewModel: PathsViewModel
    @Binding var filterTerm: String
    
    var body: some View {
        List {
            ForEach(pathsViewModel.items) { path in
                if self.filterTerm == ""
                    || path.title.lowercased().contains(self.filterTerm.lowercased())
                    || path.description.lowercased().contains(self.filterTerm.lowercased()){

                    NavigationLink(destination:
                        NavigationDetail(path: path)
                    ) {
                        PathRow(path: path)
                    }
                    .contextMenu {
                        Button(action: {
                            guard let index = self.pathsViewModel.items.firstIndex(of: path) else { return }
                            let url = self.pathsViewModel.items[index].pathProvider.url
                            self.pathsViewModel.removePaths(with: [url])
                        }) {
                            Text("Delete")
                        }
                    }
                }
            }
            .onDelete(perform: remove)
        }
        .listStyle(SidebarListStyle())
    }
    
    func remove(at offsets: IndexSet) {
        let urls = offsets.map { pathsViewModel.items[$0].pathProvider.url }
        pathsViewModel.removePaths(with: urls)
    }
}

struct FileList_Previews: PreviewProvider {
    static var previews: some View {
        PathList(pathsViewModel: PathsViewModel(), filterTerm: .constant(""))
    }
}
