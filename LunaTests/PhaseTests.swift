//
//  PhaseTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest

class PhaseTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPhasesAreCreatedFromJSON() {
        let file = NSBundle(forClass: self.dynamicType).pathForResource("moonphases", ofType: "json")
        let data = NSData(contentsOfFile: file!)
        
        if let result = data?.toJSON() {
            switch result {
            case .Success(let json):
                if let phases = Phase.phasesFromJSON(json.unbox) {
                    XCTAssertEqual(phases.count, 7, "Phases count is incorrect")
                }
            case .Failure:
                XCTFail("Failing JSONResult was found")
            }
        }
        else {
            XCTFail("No data was found")
        }
    }
    
    func testPhaseIsCreatedFromJSON() {
        let file = NSBundle(forClass: self.dynamicType).pathForResource("moonphases", ofType: "json")
        let data = NSData(contentsOfFile: file!)
        
        if let result = data?.toJSON() {
            switch result {
            case .Success(let json):
                if let response = json.unbox["response"] as? [JSON],
                    let phaseObj = response.first,
                    let phase = Phase.phaseFromJSON(phaseObj) {
                        XCTAssertEqual(phase.name, "new moon", "Phase name is incorrect")
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
