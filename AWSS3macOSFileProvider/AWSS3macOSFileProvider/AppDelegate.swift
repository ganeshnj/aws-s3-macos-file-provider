//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by Ganesh Jangir on 10/3/21.
//

import SwiftUI
import FileProvider

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("AWSS3macOSFileProviderApp starting")
  
        // List registered domains
        NSFileProviderManager.getDomainsWithCompletionHandler() { domains, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                for domain in domains {
                    print("Registered domain: \(domain.identifier.rawValue)")
                }
            }
        }
        
        // Remove all domains
        NSFileProviderManager.removeAllDomains { error in
            if let error = error {
                print("Unable to remove all domains: \(error.localizedDescription)")
            } else {
                print("Successfully removed all domains")
            }
        }
        
        // Register domain
        let domainIdentifier = "AWSS3AppDomain"
        let domainDisplayName = "AWS S3"
        let domain = NSFileProviderDomain(identifier: NSFileProviderDomainIdentifier(domainIdentifier), displayName: domainDisplayName)
        NSFileProviderManager.add(domain) { error in
            if let error = error {
                print("Unable to add file provider domain: \(error.localizedDescription)")
            } else {
                print("Successfully added file provider domain: \(domainIdentifier)")
            }
        }
        
        let manager = NSFileProviderManager(for: domain)
               
        manager?.signalEnumerator(for: .rootContainer) { error in
            if let error = error {
                print("signalEnumerator failed: \(error.localizedDescription)")
            } else {
                print("signalEnumerator succeeded")
            }
        }
    }
}
