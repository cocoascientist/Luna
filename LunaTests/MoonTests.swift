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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMoonIsCreatedFromJSON() {
        let file = NSBundle(forClass: self.dynamicType).pathForResource("sunmoon", ofType: "json")
        let data = NSData(contentsOfFile: file!)
        
        if let result = data?.toJSON() {
            switch result {
            case .Success(let json):
                if let moon = Moon.moonFromJSON(json.unbox) {
                    XCTAssertEqual(moon.phase, "waning crescent", "Moon phase is incorrect")
                    XCTAssertEqual(moon.age, 24.02, "Moon age is incorrect")
                    XCTAssertEqual(moon.illumination, 31, "Moon illumination is incorrect")
                    XCTAssertEqual(moon.percent, 0.81340000000000001, "Moon percent is incorrect")
                }
            case .Failure:
                XCTFail("Failing JSONResult was found")
            }
        }
        else {
            XCTFail("No data was found")
        }
    }
}
