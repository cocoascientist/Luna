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

class NetworkControllerTests: XCTestCase {
    
    var location: Location {
        let coordinate = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let location = Location(location: coordinate, city: "Miami", state: "FL", neighborhood: "")
        return location
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanRequestMoonSuccessfully() {
        let expectation = expectationWithDescription("Request should be successful")
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(LocalURLProtocol)
        let networkController = NetworkController(configuration: configuration)
        
        let request = AerisAPI.Moon(location.physical).request()
        
        networkController.task(request, result: { (result) -> Void in
            switch result {
            case .Success:
                expectation.fulfill()
            case .Failure:
                XCTFail("Request should not fail")
            }
        }).resume()
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testCanRequestPhasesSuccessfully() {
        let expectation = expectationWithDescription("Request should be successful")
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(LocalURLProtocol)
        let networkController = NetworkController(configuration: configuration)
        
        let request = AerisAPI.MoonPhases(location.physical).request()
        
        networkController.task(request, result: { (result) -> Void in
            switch result {
            case .Success:
                expectation.fulfill()
            case .Failure:
                XCTFail("Request should not fail")
            }
        }).resume()
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testCanHandleBadStatusCode() {
        let expectation = expectationWithDescription("Request should not be successful")
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(BadStatusURLProtocol)
        let networkController = NetworkController(configuration: configuration)
        
        let request = AerisAPI.MoonPhases(location.physical).request()
        
        networkController.task(request, result: { (result) -> Void in
            switch result {
            case .Success:
                XCTFail("Request should fail")
            case .Failure(let reason):
                expectation.fulfill()
            }
        }).resume()
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
}
