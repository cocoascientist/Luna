//
//  LocationTrackerTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/15/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import CoreLocation
import XCTest

typealias LocationUpdate = (manager: CLLocationManager) -> Void

class LocationTrackerTests: XCTestCase {
    
    class FakeLocationManager: CLLocationManager {
        let locatonUpdate: LocationUpdate
        
        init(update: LocationUpdate) {
            self.locatonUpdate = update
            super.init()
        }
        
        override func startUpdatingLocation() {
            dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
                self.locatonUpdate(manager: self)
            }
        }
        
        override func stopUpdatingLocation() {
            // nothing
        }
    }
    
    func testLocationUpdateIsPublished() {
        let fakeLocationManager = FakeLocationManager { (manager) -> Void in
            XCTAssertNotNil(manager.delegate, "Location manager delegate should not be nil")
            
            let location = CLLocation(latitude: 25.7877, longitude: -80.2241)
            manager.delegate!.locationManager?(manager, didUpdateLocations: [location])
        }
        
        let locationTracker = LocationTracker(locationManager: fakeLocationManager)
        let expectation = expectationWithDescription("Should publish location change")
        
        locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .Success(let box):
                let location = box
                XCTAssertEqual(location.physical.coordinate.latitude, 25.7877, "Latitude is wrong")
                XCTAssertEqual(location.physical.coordinate.longitude, -80.2241, "Longitude is wrong")
                expectation.fulfill()
            case .Failure:
                XCTFail("Location should be valid")
            }
        }
        
        waitForExpectationsWithTimeout(2, handler: nil)
    }
    
//    func testErrorIsPublished() {
//        let fakeLocationManager = FakeLocationManager { (manager) -> Void in
//            let error = NSError(domain: "org.andyshep.Luna", code: -1, userInfo: nil)
//            manager.delegate.locationManager?(manager, didFailWithError: error)
//        }
//        
//        let locationTracker = LocationTracker(locationManager: fakeLocationManager)
//        let expectation = expectationWithDescription("Should publish location change")
//        
//        locationTracker.addLocationChangeObserver { (result) -> () in
//            switch result {
//            case .Success:
//                XCTFail("Location should NOT be valid")
//            case .Failure:
//                expectation.fulfill()
//            }
//        }
//        
//        waitForExpectationsWithTimeout(2, handler: nil)
//    }
}
