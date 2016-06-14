//
//  NetworkError.swift
//  Luna
//
//  Created by Andrew Shepard on 11/19/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public enum NetworkError: ErrorProtocol {
    case badStatusCode(statusCode: Int)
    case badResponse
    case badJSON
    case noData
    case offline
    case other
}

extension NetworkError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .badResponse:
            return "Bad response object returned"
        case .badJSON:
            return "Bad JSON object, unable to parse"
        case .noData:
            return "No response data"
        case .offline:
            return "Offline"
        case .badStatusCode(let statusCode):
            return "Bad status code: \(statusCode)"
        case .other(let error):
            return "\(error)"
        }
    }
    
    public var summary: String {
        switch self {
        case .badResponse:
            return "Bad Response"
        case .badJSON:
            return "Bad JSON Object"
        case .noData:
            return "No Response Data"
        case .offline:
            return "Offline"
        case .badStatusCode:
            return "Bad Status Code"
        case .other:
            return "Error"
        }
    }
    
    public var message: String {
        switch self {
        case .badResponse:
            return "The server returned a bad response."
        case .badJSON:
            return "A JSON object could not be constructed from the response."
        case .noData:
            return "No response data was returned."
        case .offline:
            return "The Internet connection appears to be offline. Please check the network settings and try again"
        case .badStatusCode(let statusCode):
            return "A bad status of \(statusCode) was returned from the server. Please try again later."
        case .other:
            return "Error"
        }
    }
    
    var info: [String: String] {
        return ["title": self.summary, "message": self.message]
    }
}
