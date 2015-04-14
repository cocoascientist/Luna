//
//  LunarViewModelTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import XCTest

class LunarViewModelTests: XCTestCase {
    
    var viewModel: LunarViewModel {
        let moon = Moon("waning crescent", 24.02, 0.8134, 31, NSDate(), NSDate())
        let viewModel = LunarViewModel(moon: moon)
        return viewModel
    }

    func testCanFormatLunarAgeString() {
        XCTAssertEqual(viewModel.age, "22.20582 days old", "Age does not match")
    }
    
    func testCanFormatPercentCompleteString() {
        XCTAssertEqual(viewModel.illumination, "81.34% complete", "Percent complete does not match")
    }
    
    func testCanFormatPhaseName() {
        XCTAssertEqual(viewModel.phase, "Waning Crescent", "Phase name not match")
    }
}
