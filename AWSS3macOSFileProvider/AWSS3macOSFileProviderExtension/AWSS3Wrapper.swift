//
//  AWSS3Wrapper.swift
//  AWSS3Wrapper
//
//  Created by Ganesh Jangir on 10/3/21.
//

import Foundation
import AWSS3
import ClientRuntime
import AWSClientRuntime
import FileProvider

class AWSS3Wrapper {
    let client: S3Client
    
    init() throws {
        let creds = AWSCredentials(accessKey: "REPLACE_ME", secret: "REPLACE_ME", expirationTimeout: 30)
        let credentialsProvider = try AWSCredentialsProvider.fromStatic(creds)
        let config = try S3Client.S3ClientConfiguration(credentialsProvider: credentialsProvider, region: "us-west-2")
        self.client = S3Client(config: config)
    }
    
    func buckets(completion: @escaping (([FileProviderItem]) -> Void)) {
        let input = ListBucketsInput()
        self.client.listBuckets(input: input) { result in
            var buckets: [FileProviderItem] = []
            switch result {
            case .success(let response):
                for bucket in response.buckets ?? [] {
                    if let name = bucket.name {
                        print("[AWSS3Wrapper]: adding \(name)" )
                        buckets.append(FileProviderItem(identifier: NSFileProviderItemIdentifier(name + "/")))
                    }
                }
                completion(buckets)
            case .failure(let error):
                print("[AWSS3Wrapper]: \(error.localizedDescription)" )
                completion(buckets)
            }
        }
    }
    
    func objects(parent: String, completion: @escaping (([FileProviderItem]) -> Void)) {
        let components = parent.split(separator: "/")
        let bucket = String(components[0])
        let request = ListObjectsV2Input(bucket: bucket)
        self.client.listObjectsV2(input: request) { result in
            var objects: [FileProviderItem] = []
            switch result {
            case .success(let response):
                let identifiers = self.childIdentifiers(parent: parent, items: response.contents ?? [])
                identifiers.forEach { identifier in
                    print("[AWSS3Wrapper]: adding \(identifier)" )
                    objects.append(FileProviderItem(identifier: NSFileProviderItemIdentifier(identifier)))
                }
                completion(objects)
            case .failure(let error):
                print("[AWSS3Wrapper]: \(error.localizedDescription)")
                completion(objects)
            }
        }
    }
    
    private func childIdentifiers(parent: String, items: [S3ClientTypes.Object]) -> Set<String> {
        let parentComponents = parent.split(separator: "/")
        let parentKey = parentComponents.dropFirst().joined(separator: "/")
        let bucket = parentComponents[0]

        // filter items and take only with the same prefix
        let potentialChildItems = items.filter { item in
          item.key?.starts(with: parentKey) ?? false
        }

        var identifiers: Set<String> = []

        for item in potentialChildItems {
          guard let key = item.key else {
              continue
          }
          
          let childKey = key.deleting(prefix: parentKey)
          let components = childKey.split(separator: "/")
          if (components.count == 0) {
              print("[AWSS3Wrapper] unexpected key \(key)")
              continue;
          } else {
              // build identifier: {bucket}/{optional parentKey}/{remaining key}
              var identifier: String = String(bucket)
              if parentKey.count != 0 {
                  identifier += "/" + parentKey
              }
              identifier += "/" + components[0]
              
              // if there are more than 1 componenets i.e. it is a dir in S3
              if (components.count > 1) {
                  identifier += "/"
              }
              identifiers.insert(identifier)
          }
        }

        return identifiers
    }
}
