//
//  NSURLSessionConfiguration+Protocols.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

extension NSURLSessionConfiguration {
    class func configurationWithProtocol(protocolClass: AnyClass) -> NSURLSessionConfiguration {
        let protocolClasses: [AnyClass]? = [protocolClass]
        
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        configuration.protocolClasses = protocolClasses
        
        return configuration
    }
}