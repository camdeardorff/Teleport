//
//  PathsViewModel.swift
//  Teleport
//
//  Created by Cameron Deardorff on 9/12/20.
//

import Foundation
import AppKit
import CoreGPX
import Combine
import SwiftUI

class PathsViewModel: ObservableObject {
    @Published var items: [PathSimulationProvider] = []
    @Published var hasError: Bool = false
    @Published var error: GPXFilesControllerError? = nil
    
    private lazy var gpxFilesController = GPXFilesController()
    private var itemsCancellable: AnyCancellable? = nil
    private var errorCancellable: AnyCancellable? = nil
    
    init() {
        // initial set
        items = gpxFilesController.items
        // listen for changes
        itemsCancellable = gpxFilesController.itemsPublisher.sink(receiveValue: {
            [weak self] items  in
            print("receiving items: ", items.count)
            guard let strongSelf = self else { return }
            print("setting items")
            strongSelf.items = items
        })
        errorCancellable = gpxFilesController.errorPublisher.sink(receiveValue: {
            [weak self] (error) in
            print("receiving error")
            guard let strongSelf = self else { return }
            print("setting error")
            strongSelf.hasError = true
            strongSelf.error = error
        })
    }
    
    func openFile() {
        gpxFilesController.openFile()
    }
    
    func removePaths(with urls: [URL]) {
        gpxFilesController.removePaths(with: urls)
    }
}
