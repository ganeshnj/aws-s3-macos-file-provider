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
        var buckets: [FileProviderItem] = []
        let input = ListBucketsInput()
        client.listBuckets(input: input) { result in
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
}
