//
//  Reason.swift
//  Luna
//
//  Created by Andrew Shepard on 1/25/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public enum Reason {
    case BadResponse
    case BadJSON
    case NoData
    case NoSuccessStatusCode(statusCode: Int)
    case Other(NSError)
}

extension Reason: CustomStringConvertible {
    public var description: String {
        switch self {
        case .BadResponse:
            return "Bad response object returned"
        case .BadJSON:
            return "Bad JSON object, unable to parse"
        case .NoData:
            return "No response data"
        case .NoSuccessStatusCode(let statusCode):
            return "Bad status code: \(statusCode)"
        case .Other(let error):
            return "\(error)"
        }
    }
}