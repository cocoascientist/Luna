//
//  Requestable.swift
//  Luna
//
//  Created by Andrew Shepard on 11/19/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public typealias Parameters = [String: String]

public protocol Requestable {
    var baseURL: URL { get }
    var path: String { get }
    var parameters: Parameters { get }
    
    var request: URLRequest { get }
}
