//
//  AerisAPI.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

enum AerisAPI: Request {
    case Moon(CLLocation)
    case MoonPhases(CLLocation)
    
    var baseURL: NSURL {
        return NSURL(string: "https://api.aerisapi.com")!
    }
    
    var parameters: [String: String] {
        switch self {
        case .Moon:
            return ["client_id": clientId, "client_secret": clientSecret]
        case .MoonPhases:
            return ["client_id": clientId, "client_secret": clientSecret, "limit": "5"]
        }
    }
    
    var path: String {
        switch self {
        case .Moon(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let queryString = queryWithParameters(parameters)
            return "\(baseURL)/sunmoon/\(latitude),\(longitude)?\(queryString)"
        case .MoonPhases(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let queryString = queryWithParameters(parameters)
            return "\(baseURL)/sunmoon/moonphases/\(latitude),\(longitude)?\(queryString)"
        }
    }
    
    var request: NSURLRequest {
        let path = self.path
        guard let url = NSURL(string: path) else { fatalError("bad url") }
        return NSURLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
    }
}

extension AerisAPI {
    private var clientSecret: String {
        fatalError("client secret not defined")
    }
    
    private var clientId: String {
        fatalError("client id not defined")
    }
}