//
//  MoonTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest

class MoonTests: XCTestCase {
    
    func testMoonIsCreatedFromJSON() {
        let file = Bundle(for: self.dynamicType).pathForResource("sunmoon", ofType: "json")
        let data = Data(contentsOfFile: file!)
        
        do {
            guard let json = try data?.toJSON() else { return XCTFail("No data was found") }
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
