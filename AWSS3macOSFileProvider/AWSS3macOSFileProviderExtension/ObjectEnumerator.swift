//
//  ObjectEnumerator.swift
//  ObjectEnumerator
//
//  Created by Ganesh Jangir on 10/3/21.
//

import Foundation
import FileProvider

class ObjectEnumerator: NSObject, NSFileProviderEnumerator {
    let parent: NSFileProviderItemIdentifier
    
    init(parent: NSFileProviderItemIdentifier) {
        self.parent = parent
    }
    
    func invalidate() {
    }
    
    func enumerateItems(for observer: NSFileProviderEnumerationObserver, startingAt page: NSFileProviderPage) {
        do {
            let wrapper = try AWSS3Wrapper()
            wrapper.objects(parent: self.parent.rawValue) { [observer] items in
                observer.didEnumerate(items)
                observer.finishEnumerating(upTo: nil)
            }
        } catch {
            observer.didEnumerate([])
            observer.finishEnumerating(upTo: nil)
        }
    }
}

extension String {
    func deleting(prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
