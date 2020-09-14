//
//  NavigationPrimary.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/1/20.
//

import SwiftUI
import AppKit
import CoreGPX

struct NavigationPrimary: View {
    @State var searchTerm: String = ""
    @ObservedObject var viewModel: PathsViewModel = PathsViewModel()
    
    @State var showError: Bool = false
    @State var error: GPXFilesControllerError? = nil
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(searchTerm: $searchTerm)
                Button(action: {
                    viewModel.openFile()
                }) {
                    Image("plus")
                        .resizable()
                        .frame(width: 12, height:12)
                }
                .buttonStyle(BorderlessButtonStyle())
                
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            
            PathList(pathsViewModel: viewModel, filterTerm: $searchTerm)
                .listStyle(SidebarListStyle())
            
        }
        .frame(minWidth: 200, maxWidth: 400)
        .alert(isPresented: $viewModel.hasError) { () -> Alert in
            Alert(
                title: Text("Something went wrong"),
                message: Text(viewModel.error?.desription ?? "Hmmm, there was a problem getting the error message too. :("),
                dismissButton: .default(Text("OK")))
        }
    }
}

struct NavigationPrimary_Previews: PreviewProvider {
    static var previews: some View {
        NavigationPrimary()
    }
}
