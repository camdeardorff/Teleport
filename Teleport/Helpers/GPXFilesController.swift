//
//  GPXFilesController.swift
//  Teleport
//
//  Created by Cameron Deardorff on 9/12/20.
//

import Foundation
import AppKit
import Combine
import CoreGPX

enum GPXFilesControllerError: Error {
    case getGPXDirFailed
    case copyFileFailed
    case listFilesFailed
    case deleteFileFailed
    case invalidFileType
    case cannotParseFile
    
    var desription: String {
        switch self {
        case .getGPXDirFailed: return "Could not get or create GPX folder."
        case .copyFileFailed: return "Could not add file."
        case .listFilesFailed: return "Could not list files in GPX folder."
        case .deleteFileFailed: return "Could not delete file."
        case .invalidFileType: return "Invalid file type, only GPX files are allowed."
        case .cannotParseFile: return "GPX file cannot be parsed."
        }
    }
}

class GPXFilesController {
    
    let itemsPublisher = PassthroughSubject<[PathSimulationProvider], Never>()
    let errorPublisher = PassthroughSubject<GPXFilesControllerError, Never>()
    
    var items: [PathSimulationProvider] = []
    
    init() {
        pushItems()
    }
    
    private var gpxDir: URL? {
        guard let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        else { return nil }
        
        guard let appSupportDir = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
        else { return nil }
        
        let gpxDir = appSupportDir.appendingPathComponent("\(appName)/gpx")
        if !FileManager.default.fileExists(atPath: gpxDir.absoluteString) {
            do {
                try FileManager.default.createDirectory(
                    at: gpxDir,
                    withIntermediateDirectories: true,
                    attributes: nil)
            } catch let e {
                print("could not create gpx dir: ", e)
                return nil
            }
        }
        return gpxDir
    }
    
    
    func openFile() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        panel.begin { [weak self] (response) in
            
            guard let strongSelf = self,
                  response == NSApplication.ModalResponse.OK else { return }
            guard let gpxDir = strongSelf.gpxDir else {
                strongSelf.errorPublisher.send(.getGPXDirFailed)
                return
            }
            
            panel.urls.forEach { url in
                guard url.pathExtension == "gpx" else {
                    strongSelf.errorPublisher.send(.invalidFileType)
                    return
                }
                guard (GPXParser(withURL: url)) != nil else {
                    strongSelf.errorPublisher.send(.cannotParseFile)
                    return
                }
                
                let saveUrl = gpxDir.appendingPathComponent(url.lastPathComponent)
                do {
                    try FileManager.default.copyItem(at: url, to: saveUrl)
                } catch let e {
                    print("failed to copy \(url) to \(saveUrl) - \(e)")
                    strongSelf.errorPublisher.send(.copyFileFailed)
                }
            }
                
            strongSelf.pushItems()
        }
    }
    
    func pushItems() {
        items = fetchItems()
        itemsPublisher.send(items)
    }
    private func fetchItems() -> [PathSimulationProvider] {
        
        guard let gpxDir = gpxDir else {
            errorPublisher.send(.getGPXDirFailed)
            return []
        }
        
        var fileUrls: [URL] = []
        do {
            fileUrls = try FileManager.default.contentsOfDirectory(at: gpxDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch let e {
            print("could not look up contents of dir \(gpxDir) - \(e)")
            errorPublisher.send(.listFilesFailed)
        }
        
        let gpxFiles: [GPXFile] = fileUrls.compactMap({
            guard let data = GPXParser(withURL: $0)?.parsedData() else { return nil }
            return GPXFile(
                name: $0.lastPathComponent,
                url: $0,
                title: data.deepName,
                description: data.deepDescription,
                path: data.path)
        })
        
        let pathProviders: [PathSimulationProvider] = gpxFiles.compactMap {
            PathSimulationProvider(
                pathProvider: $0,
                duration: 360,
                interpolate: false,
                pathType: PathType.bestGuess(for: $0.path) ?? .outAndBack)
        }
        
        return pathProviders
    }
    
    func removePaths(with urls: [URL]) {
        urls.forEach(removePath)
    }
    
    func removePath(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch let e {
            print("could not delete file - \(e)")
            errorPublisher.send(.listFilesFailed)
        }
        pushItems()
    }
}
