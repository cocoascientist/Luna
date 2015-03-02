//
//  Luna.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct Moon {
    let phase: String
    let percent: Double
    
    let age: Double
    let angle: Double
    let illumination: Double
    
    let rise: NSDate
    let set: NSDate
}

struct Sun {
    let rise: NSDate
    let set: NSDate
}