//
//  BucketsEnumerator.swift
//  BucketsEnumerator
//
//  Created by Ganesh Jangir on 10/3/21.
//

import Foundation

import FileProvider

class BucketEnumerator: NSObject, NSFileProviderEnumerator {
    let wrapper: AWSS3Wrapper
    
    init(wrapper: AWSS3Wrapper) {
        self.wrapper = wrapper
    }
    
    func invalidate() {
    }
    
    func enumerateItems(for observer: NSFileProviderEnumerationObserver, startingAt page: NSFileProviderPage) {
        wrapper.buckets { items in
            observer.didEnumerate(items)
            observer.finishEnumerating(upTo: nil)
        }
    }
}
