//
//  LunaError.swift
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
