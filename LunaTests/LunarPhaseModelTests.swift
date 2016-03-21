//
//  LunarPhaseModelTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/13/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

let timeout = 60.0

class LunarPhaseModelTests: XCTestCase {
    
    var location: Location {
        let coordinate = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let location = Location(location: coordinate, city: "Miami", state: "FL", neighborhood: "")
        return location
    }

    func testMoonDidUpdateNotificationIsPosted() {
        let model = modelUsingProtocol(LocalURLProtocol)
        model.updateLunarPhase(location)
        
        waitForAndExpectNotification(MoonDidUpdateNotification)
    }
    
    func testPhasesDidUpdateNotificationIsPosted() {
        let model = modelUsingProtocol(LocalURLProtocol)
        model.updateLunarPhase(location)
        
        waitForAndExpectNotification(PhasesDidUpdateNotification)
    }
    
    func testErrorNotificationIsPosted() {
        let model = modelUsingProtocol(FailingURLProtocol)
        model.updateLunarPhase(location)
        
        waitForAndExpectNotification(LunarModelDidReceiveErrorNotification)
    }
    
    // MARK: - Private
    
    private func waitForAndExpectNotification(name:String) -> Void {
        let expected = expectation(withDescription: "Notification should be posted")
        var token: dispatch_once_t = 0
        
        let responseBlock = { (notification: NSNotification!) -> Void in
            dispatch_once(&token, { () -> Void in
                expected.fulfill()
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserver(forName: name, object: nil, queue: nil, using: responseBlock)
        
        waitForExpectations(withTimeout: timeout, handler: nil)
    }

    private func modelUsingProtocol(protocolClass: AnyClass) -> LunarPhaseModel {
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(protocolClass)
        let networkController = NetworkController(configuration: configuration)
        return LunarPhaseModel(networkController: networkController)
    }
}
