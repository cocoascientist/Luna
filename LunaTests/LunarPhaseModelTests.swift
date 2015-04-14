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

typealias ResponseBlock = (notification: NSNotification!) -> Void

class LunarPhaseModelTests: XCTestCase {
    
    var location: Location {
        let coordinate = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let location = Location(location: coordinate, city: "Miami", state: "FL", neighborhood: "")
        return location
    }

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testMoonDidUpdateNotificationIsPosted() {
        let name = MoonDidUpdateNotification
        let lunarPhaseModel = lunarPhaseModelUsingProtocol(TestURLProtocol)
        expectNotificationNamed(name, fromModel: lunarPhaseModel)
    }
    
    func testPhasesDidUpdateNotificationIsPosted() {
        let name = PhasesDidUpdateNotification
        let lunarPhaseModel = lunarPhaseModelUsingProtocol(TestURLProtocol)
        expectNotificationNamed(name, fromModel: lunarPhaseModel)

    }
    
    func testErrorNotificationIsPosted() {
        let name = LunarModelDidReceiveErrorNotification
        let lunarPhaseModel = lunarPhaseModelUsingProtocol(FailingURLProtocol)
        expectNotificationNamed(name, fromModel: lunarPhaseModel)
    }
    
    func testCanHandleBadResponse() {
        let name = LunarModelDidReceiveErrorNotification
        let lunarPhaseModel = lunarPhaseModelUsingProtocol(BadResponseURLProtocol)
        expectNotificationNamed(name, fromModel: lunarPhaseModel)
    }
    
    func testCanHandleBadStatusCode() {
        let name = LunarModelDidReceiveErrorNotification
        let lunarPhaseModel = lunarPhaseModelUsingProtocol(BadStatusURLProtocol)
        expectNotificationNamed(name, fromModel: lunarPhaseModel)
    }
    
    func expectNotificationNamed(name:String, fromModel model:LunarPhaseModel) -> Void {
        let expectation = expectationWithDescription("Notification should be posted")
        var token: dispatch_once_t = 0
        
        let responseBlock = { (notification: NSNotification!) -> Void in
            dispatch_once(&token, { () -> Void in
                expectation.fulfill()
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: nil, usingBlock: responseBlock)
        model.updateLunarPhase(location)
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }

    func lunarPhaseModelUsingProtocol(protocolClass: AnyObject) -> LunarPhaseModel {
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(protocolClass)
        let networkController = NetworkController(configuration: configuration)
        return LunarPhaseModel(networkController: networkController)
    }
}
