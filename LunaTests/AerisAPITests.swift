//
//  AerisAPITests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

class AerisAPITests: XCTestCase {
    
    var location: Location {
        let coordinate = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let location = Location(location: coordinate, city: "Miami", state: "FL", neighborhood: "")
        return location
    }

    func testCanGenerateMoonRequest() {
        let request = AerisAPI.Moon(location.physical).request
        
        XCTAssertNotNil(request.url, "Request URL should not be nil")
        XCTAssertEqual(request.url!.path!, "/sunmoon/25.7877,-80.2241", "Request URL path is wrong")
        
        let parameters = queryParameters(request.url!.query!)
        
        XCTAssertTrue(parameters.contains("client_id"), "client_id query parameter is missing")
        XCTAssertTrue(parameters.contains("client_secret"), "client_secret query parameter is missing")
    }
    
    func testCanGeneratePhasesRequest() {
        let request = AerisAPI.MoonPhases(location.physical).request
        
        XCTAssertNotNil(request.url, "URL should not be nil")
        XCTAssertEqual(request.url!.path!, "/sunmoon/moonphases/25.7877,-80.2241", "Request URL path is wrong")
        
        let parameters = queryParameters(request.url!.query!)
        
        XCTAssertTrue(parameters.contains("client_id"), "client_id query parameter is missing")
        XCTAssertTrue(parameters.contains("client_secret"), "client_secret query parameter is missing")
        XCTAssertTrue(parameters.contains("limit"), "limit query parameter is missing")
    }
    
    private func queryParameters(_ string: String) -> [String] {
        let pairs = string.characters.split { $0 == "&" }.map { String($0) }
        let params = pairs.map({ (string) -> String in
            let value = string.characters.split { $0 == "=" }.map { String($0) } as [String]
            return value.first!
        })
        
        return params
    }
}
