//
//  Request.swift
//  Luna
//
//  Created by Andrew Shepard on 11/19/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public typealias Parameters = [String: String]

public protocol Request {
    var baseURL: NSURL { get }
    var path: String { get }
    var parameters: Parameters { get }
    
    var request: NSURLRequest { get }
}

extension Request {
    var path: String { return "" }
    var parameters: Parameters { return [:] }
}
