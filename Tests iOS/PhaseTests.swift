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
        let file = Bundle(for: type(of: self)).url(forResource: "moonphases", withExtension: "json")!
        let data = try! Data(contentsOf: file)
        
        let result = PhasesResultFromData(data)
        switch result {
        case .success(let phases):
            XCTAssertEqual(phases.count, 7, "Phases count is incorrect")
        case .failure:
            XCTFail("Failing JSONResult was found")
        }
    }
}
