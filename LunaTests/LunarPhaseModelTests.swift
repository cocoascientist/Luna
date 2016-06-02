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
        let model = modelUsingProtocol(LocalURLProtocol.self)
        model.updateLunarPhase(location: location)
        
        waitForAndExpectNotificationNamed(MoonDidUpdateNotification)
    }
    
    func testPhasesDidUpdateNotificationIsPosted() {
        let model = modelUsingProtocol(LocalURLProtocol.self)
        model.updateLunarPhase(location: location)
        
        waitForAndExpectNotificationNamed(PhasesDidUpdateNotification)
    }
    
    func testErrorNotificationIsPosted() {
        let model = modelUsingProtocol(FailingURLProtocol.self)
        model.updateLunarPhase(location: location)
        
        waitForAndExpectNotificationNamed(LunarModelDidReceiveErrorNotification)
    }
    
    // MARK: - Private
    
    private func waitForAndExpectNotificationNamed(_ name:String) -> Void {
        let expected = expectation(withDescription: "Notification should be posted")
        var token: dispatch_once_t = 0
        
        let responseBlock = { (notification: NSNotification!) -> Void in
            dispatch_once(&token, { () -> Void in
                expected.fulfill()
            })
        }
        
        NSNotificationCenter.default().addObserver(forName: name, object: nil, queue: nil, using: responseBlock)
        
        waitForExpectations(withTimeout: timeout, handler: nil)
    }

    private func modelUsingProtocol(_ protocolClass: AnyClass) -> LunarPhaseModel {
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(protocolClass: protocolClass)
        let networkController = NetworkController(configuration: configuration)
        return LunarPhaseModel(networkController: networkController)
    }
}
