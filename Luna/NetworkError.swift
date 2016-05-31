//
//  NetworkError.swift
//  Luna
//
//  Created by Andrew Shepard on 11/19/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public enum NetworkError: ErrorProtocol {
    case BadStatusCode(statusCode: Int)
    case BadResponse
    case BadJSON
    case NoData
    case Offline
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
        case .Offline:
            return "Offline"
        case .BadStatusCode(let statusCode):
            return "Bad status code: \(statusCode)"
        case .Other(let error):
            return "\(error)"
        }
    }
    
    public var summary: String {
        switch self {
        case .BadResponse:
            return "Bad Response"
        case .BadJSON:
            return "Bad JSON Object"
        case .NoData:
            return "No Response Data"
        case .Offline:
            return "Offline"
        case .BadStatusCode:
            return "Bad Status Code"
        case .Other:
            return "Error"
        }
    }
    
    public var message: String {
        switch self {
        case .BadResponse:
            return "The server returned a bad response."
        case .BadJSON:
            return "A JSON object could not be constructed from the response."
        case .NoData:
            return "No response data was returned."
        case .Offline:
            return "The Internet connection appears to be offline. Please check the network settings and try again"
        case .BadStatusCode(let statusCode):
            return "A bad status of \(statusCode) was returned from the server. Please try again later."
        case .Other:
            return "Error"
        }
    }
    
    var info: [String: String] {
        return ["title": self.summary, "message": self.message]
    }
}