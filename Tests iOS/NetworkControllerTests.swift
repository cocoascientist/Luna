//
//  NetworkControllerTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

@testable import Luna

class NetworkControllerTests: XCTestCase {
    
    var location: Location {
        let coordinate = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let location = Location(location: coordinate, city: "Miami", state: "FL", neighborhood: "")
        return location
    }

//    func testCanRequestMoonSuccessfully() {
//        let expected = expectation(description: "Request should be successful")
//        let configuration = URLSessionConfiguration.configurationWithProtocol(LocalURLProtocol.self)
//        let networkController = NetworkController(configuration: configuration)
//        
//        let request = AerisAPI.moon(location.physical).request
//        
//        networkController.start(request, result: { (result) -> Void in
//            switch result {
//            case .success:
//                expected.fulfill()
//            case .failure:
//                XCTFail("Request should not fail")
//            }
//        })
//        
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//    
//    func testCanRequestPhasesSuccessfully() {
//        let expected = expectation(description: "Request should be successful")
//        let configuration = URLSessionConfiguration.configurationWithProtocol(LocalURLProtocol.self)
//        let networkController = NetworkController(configuration: configuration)
//        
//        let request = AerisAPI.moonPhases(location.physical).request
//        
//        networkController.start(request, result: { (result) -> Void in
//            switch result {
//            case .success:
//                expected.fulfill()
//            case .failure:
//                XCTFail("Request should not fail")
//            }
//        })
//        
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//    
//    func testCanHandleBadStatusCode() {
//        let expected = expectation(description: "Request should not be successful")
//        let configuration = URLSessionConfiguration.configurationWithProtocol(BadStatusURLProtocol.self)
//        let networkController = NetworkController(configuration: configuration)
//        
//        let request = AerisAPI.moonPhases(location.physical).request
//        
//        networkController.start(request, result: { (result) -> Void in
//            switch result {
//            case .success:
//                XCTFail("Request should fail")
//            case .failure:
//                expected.fulfill()
//            }
//        })
//        
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
}
