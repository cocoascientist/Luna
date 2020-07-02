//
//  File.swift
//  Luna
//
//  Created by Andrew Shepard on 6/30/20.
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
