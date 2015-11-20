//
//  NetworkError.swift
//  Luna
//
//  Created by Andrew Shepard on 11/19/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public enum NetworkError: ErrorType {
    case BadStatusCode(statusCode: Int)
    case BadResponse
    case BadJSON
    case NoData
    case Other
}

extension NetworkError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .BadResponse:
            return "Bad response object returned"
        case .BadJSON:
            return "Bad JSON object, unable to parse"
        case .NoData:
            return "No response data"
        case .BadStatusCode(let statusCode):
            return "Bad status code: \(statusCode)"
        case .Other(let error):
            return "\(error)"
        }
    }
}