//
//  AerisAPI.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

enum AerisAPI {
    case Moon(CLLocation)
    case MoonPhases(CLLocation)
}

extension AerisAPI {
    private var clientSecret: String {
        return "pNqJnVTj65P0IXmGwz7Vk3GJy8TO3xnTlTGYd7e2"
    }
    
    private var clientId: String {
        return "qO0MwrGSnfBKizM4B9Bt7"
    }
    
    private var baseURL: String {
        return "https://api.aerisapi.com"
    }
    
    private var path: String {
        switch self {
        case .Moon(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            return "\(baseURL)/sunmoon/\(latitude),\(longitude)?client_id=\(clientId)&client_secret=\(clientSecret)"
        case .MoonPhases(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            return "\(baseURL)/sunmoon/moonphases/\(latitude),\(longitude)?client_id=\(clientId)&client_secret=\(clientSecret)&limit=5"
        }
    }
    
    func request() -> NSURLRequest {
        let path = self.path
        let url = NSURL(string: path)
        return NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60.0)
    }
}