//
//  PhaseTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest

@testable import Luna

class PhaseTests: XCTestCase {

    func testPhasesAreCreatedFromJSON() {
        let file = Bundle(for: type(of: self)).url(forResource: "moonphases", withExtension: "json")
        let data = try! Data(contentsOf: file!)
        
        do {
            let json = try data.toJSON()
            let result = Phase.phasesFromJSON(json)
            switch result {
            case .success(let phases):
                XCTAssertEqual(phases.count, 7, "Phases count is incorrect")
            case .failure:
                XCTFail("Failing JSONResult was found")
            }
        }
        catch {
            XCTFail("Failing JSONResult was found")
        }
    }
    
    func testPhaseIsCreatedFromJSON() {
        let file = Bundle(for: type(of: self)).url(forResource: "moonphases", withExtension: "json")
        let data = try! Data(contentsOf: file!)
        
        do {
            let json = try data.toJSON()
            if let response = json["response"] as? [JSON],
                let phaseObj = response.first,
                case .success(let phase) = Phase.phaseFromJSON(phaseObj) {
                XCTAssertEqual(phase.name, "new moon", "Phase name is incorrect")
            }
            else {
                XCTFail("Failing JSONResult was found")
            }
        }
        catch {
            XCTFail("Failing JSONResult was found")
        }
    }
}
