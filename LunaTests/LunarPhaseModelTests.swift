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

class LunarPhaseModelTests: XCTestCase {
    
    var lunarPhaseModel: LunarPhaseModel!
    
    let location = Location(location: CLLocation(latitude: 25.7877, longitude: -80.2241), city: "Miami", state: "FL", neighborhood: "")

    override func setUp() {
        super.setUp()

        var protocolClasses = [AnyObject]()
        protocolClasses.append(TestURLProtocol)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.protocolClasses = protocolClasses
        
        let networkController = NetworkController(configuration: configuration)
        self.lunarPhaseModel = LunarPhaseModel(networkController: networkController)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLunarModelUpdateNotificationIsPosted() {
        let expectation = expectationWithDescription("Model update notification should be posted")
        var token: dispatch_once_t = 0
        
        let responseBlock = { (notification: NSNotification!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                dispatch_once(&token, { () -> Void in
                    expectation.fulfill()
                    
                    let result = self.lunarPhaseModel.currentMoon
                    
                    switch result {
                    case .Success(let box):
                        let moon = box.unbox
                        
                        XCTAssertEqual(moon.phase, "waning crescent", "Lunar phase name does not match")
                        XCTAssertEqual(moon.age, 24.02, "Lunar phase age does not match")
                    case .Failure(let reason):
                        XCTFail("Error unboxing Moon: \(reason.description)")
                    }
                })
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(LunarModelDidUpdateNotification, object: nil, queue: nil, usingBlock: responseBlock)
        
        lunarPhaseModel.updateLunarPhase(location)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testPhasesUpdateNotifictionIsPosted() {
        let expectation = expectationWithDescription("Phases update notification should be posted")
        var token: dispatch_once_t = 0
        
        let responseBlock = { (notification: NSNotification!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                dispatch_once(&token, { () -> Void in
                    expectation.fulfill()
                    
                    let result = self.lunarPhaseModel.currentPhases
                    
                    switch result {
                    case .Success(let box):
                        let phases = box.unbox
                        XCTAssertEqual(phases.count, 7, "Phases count does not match")
                    case .Failure(let reason):
                        XCTFail("Error unboxing Moon: \(reason.description)")
                    }
                })
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(PhasesDidUpdateNotification, object: nil, queue: nil, usingBlock: responseBlock)
        
        lunarPhaseModel.updateLunarPhase(location)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }

}
