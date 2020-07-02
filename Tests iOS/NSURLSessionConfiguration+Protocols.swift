//
//  NSURLSessionConfiguration+Protocols.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

extension URLSessionConfiguration {
    class func configurationWithProtocol(_ protocolClass: AnyClass) -> URLSessionConfiguration {
        let protocolClasses: [AnyClass]? = [protocolClass]
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = protocolClasses
        
        return configuration
    }
}
