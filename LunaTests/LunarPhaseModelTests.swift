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
        model.updateLunarPhase(using: location)
        
        waitForAndExpectNotificationNamed(MoonDidUpdateNotification)
    }
    
    func testPhasesDidUpdateNotificationIsPosted() {
        let model = modelUsingProtocol(LocalURLProtocol.self)
        model.updateLunarPhase(using: location)
        
        waitForAndExpectNotificationNamed(PhasesDidUpdateNotification)
    }
    
    func testErrorNotificationIsPosted() {
        let model = modelUsingProtocol(FailingURLProtocol.self)
        model.updateLunarPhase(using: location)
        
        waitForAndExpectNotificationNamed(LunarModelDidReceiveErrorNotification)
    }
    
    // MARK: - Private
    
    private func waitForAndExpectNotificationNamed(_ name:String) -> Void {
        let expected = expectation(description: "Notification should be posted")
        var token: Int = 0
        
        let responseBlock = { (notification: Notification!) -> Void in
            //
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: nil, queue: nil, using: responseBlock)
        
        waitForExpectations(timeout: timeout, handler: nil)
    }

    private func modelUsingProtocol(_ protocolClass: AnyClass) -> LunarPhaseModel {
        let configuration = URLSessionConfiguration.configurationWithProtocol(protocolClass)
        let networkController = NetworkController(configuration: configuration)
        return LunarPhaseModel(networkController: networkController)
    }
}
