//
//  FileProviderItem.swift
//  AWSS3macOSFileProviderExtension
//
//  Created by Ganesh Jangir on 10/3/21.
//

import FileProvider
import UniformTypeIdentifiers

class FileProviderItem: NSObject, NSFileProviderItem {

    // TODO: implement an initializer to create an item from your extension's backing model
    // TODO: implement the accessors to return the values from your extension's backing model
    
    private let identifier: NSFileProviderItemIdentifier
    
    init(identifier: NSFileProviderItemIdentifier) {
        self.identifier = identifier
    }
    
    var itemIdentifier: NSFileProviderItemIdentifier {
        return identifier
    }
    
    var parentItemIdentifier: NSFileProviderItemIdentifier {
        return .rootContainer
    }
    
    var capabilities: NSFileProviderItemCapabilities {
        return [.allowsReading, .allowsWriting, .allowsRenaming, .allowsReparenting, .allowsTrashing, .allowsDeleting]
    }
    
    var itemVersion: NSFileProviderItemVersion {
        NSFileProviderItemVersion(contentVersion: "a content version".data(using: .utf8)!, metadataVersion: "a metadata version".data(using: .utf8)!)
    }
    
    var filename: String {
        let components = identifier.rawValue.split(separator: "/")
        guard let last = components.last else {
            print("[FileProviderItem] last component cannot be nil")
            return identifier.rawValue
        }
        let name = String(last)
        return name
    }
    
    var contentType: UTType {
        if identifier == NSFileProviderItemIdentifier.rootContainer {
              return .folder
          }
        
        guard let lastChar = identifier.rawValue.last else {
            print("[FileProviderItem] last char cannot be nil")
            return .folder
        }
        
        let type: UTType = lastChar == "/" ? .folder : .item
        return type
    }
}
