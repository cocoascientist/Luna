//
//  Request.swift
//  Luna
//
//  Created by Andrew Shepard on 11/19/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

protocol Request {
    var baseURL: URL { get }
    var path: String { get }
    var parameters: Parameters { get }
    
    var request: URLRequest { get }
}

extension Request {
    var path: String { return "" }
    var parameters: Parameters { return [:] }
}
