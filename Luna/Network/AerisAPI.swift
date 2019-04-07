//
//  AerisAPI.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

enum AerisAPI: Requestable {
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
            let queryString = parameters.queryString
            return "\(baseURL)/sunmoon/\(latitude),\(longitude)?\(queryString)"
        case .moonPhases(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let queryString = parameters.queryString
            return "\(baseURL)/sunmoon/moonphases/\(latitude),\(longitude)?\(queryString)"
        }
    }
    
    var request: URLRequest {
        let path = self.path
        guard let url = URL(string: path) else { fatalError("bad url") }
        return URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
    }
}

private extension AerisAPI {
    private var clientSecret: String {
        return "0Fwa3rF6tIxwwUatBeHTncGkAZQ9FK88NhIOl8xB"
    }
    
    private var clientId: String {
        return "zFFXOpPPz6XfaUz20tWEQ"
    }
}
