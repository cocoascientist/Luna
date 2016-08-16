//
//  MoonTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest

@testable import Luna

class MoonTests: XCTestCase {
    
    func testMoonIsCreatedFromJSON() {
        let file = Bundle(for: type(of: self)).url(forResource: "sunmoon", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: file!)
            let json = try data.toJSON()
            guard let moon = Moon(json: json) else { return XCTFail("Could not create moon") }
            
            XCTAssertEqual(moon.phase, "waning crescent", "Moon phase is incorrect")
            XCTAssertEqual(moon.age, 24.02, "Moon age is incorrect")
            XCTAssertEqual(moon.illumination, 31, "Moon illumination is incorrect")
            XCTAssertEqual(moon.percent, 0.81340000000000001, "Moon percent is incorrect")
        }
        catch {
            XCTFail("Failing JSONResult was found")
        }
    }
}
