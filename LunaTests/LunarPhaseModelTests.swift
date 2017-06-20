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

@testable import Luna

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
        
        waitForAndExpectNotification(named: Notification.Name.didUpdateMoon.rawValue)
    }
    
    func testPhasesDidUpdateNotificationIsPosted() {
        let model = modelUsingProtocol(LocalURLProtocol.self)
        model.updateLunarPhase(using: location)
        
        waitForAndExpectNotification(named: Notification.Name.didUpdatePhases.rawValue)
    }
    
    func testErrorNotificationIsPosted() {
        let model = modelUsingProtocol(FailingURLProtocol.self)
        model.updateLunarPhase(using: location)
        
        waitForAndExpectNotification(named: Notification.Name.didReceiveLunarModelError.rawValue)
    }
    
    // MARK: - Private
    
    fileprivate func waitForAndExpectNotification(named name: String) -> Void {
        let expected = expectation(description: "Notification should be posted")
        var token: Int = 0
        
        let responseBlock = { (notification: Notification!) -> Void in
            if token == 0 {
                token += 1
                expected.fulfill()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: name), object: nil, queue: nil, using: responseBlock)
        
        waitForExpectations(timeout: timeout, handler: nil)
    }

    private func modelUsingProtocol(_ protocolClass: AnyClass) -> LunarPhaseModel {
        let configuration = URLSessionConfiguration.configurationWithProtocol(protocolClass)
        let networkController = NetworkController(configuration: configuration)
        return LunarPhaseModel(networkController: networkController)
    }
}
