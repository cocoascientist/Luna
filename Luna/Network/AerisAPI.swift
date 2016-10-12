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
    case moon(CLLocation)
    case moonPhases(CLLocation)
    
    var baseURL: URL {
        return URL(string: "https://api.aerisapi.com")!
    }
    
    var parameters: [String: String] {
        switch self {
        case .moon:
            return ["client_id": clientId, "client_secret": clientSecret]
        case .moonPhases:
            return ["client_id": clientId, "client_secret": clientSecret, "limit": "5"]
        }
    }
    
    var path: String {
        switch self {
        case .moon(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let queryString = query(with: parameters)
            return "\(baseURL)/sunmoon/\(latitude),\(longitude)?\(queryString)"
        case .moonPhases(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let queryString = query(with: parameters)
            return "\(baseURL)/sunmoon/moonphases/\(latitude),\(longitude)?\(queryString)"
        }
    }
    
    var request: URLRequest {
        let path = self.path
        guard let url = URL(string: path) else { fatalError("bad url") }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
    }
}

extension AerisAPI {
    fileprivate var clientSecret: String {
        fatalError("client secret not defined")
    }
    
    fileprivate var clientId: String {
        fatalError("client id not defined")
    }
}
