//
//  BucketsEnumerator.swift
//  BucketsEnumerator
//
//  Created by Ganesh Jangir on 10/3/21.
//

import Foundation

import FileProvider

class BucketEnumerator: NSObject, NSFileProviderEnumerator {
    func invalidate() {
    }
    
    func enumerateItems(for observer: NSFileProviderEnumerationObserver, startingAt page: NSFileProviderPage) {
        do {
            let wrapper = try AWSS3Wrapper()
            wrapper.buckets { [observer] items in
                observer.didEnumerate(items)
                observer.finishEnumerating(upTo: nil)
            }
        } catch {
            observer.didEnumerate([])
            observer.finishEnumerating(upTo: nil)
        }
    }
}
