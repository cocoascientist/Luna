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
    let age: Double
    let percent: Double
    
    let illumination: Int
    
    let rise: NSDate
    let set: NSDate
    
    init(_ phase: String, _ age: Double, _ percent: Double, _ illumination: Int, _ rise: NSDate, _ set: NSDate) {
        self.phase = phase
        self.age = age
        self.percent = percent
        self.illumination = illumination
        self.rise = rise
        self.set = set
    }
}

extension Moon {
    static func moonFromJSON(json: JSON) -> Moon? {
        
        guard
            let response = json["response"] as? [JSON],
            let moon = response.first?["moon"] as? JSON,
            let phase = moon["phase"] as? JSON,
            let phaseName = phase["name"] as? String,
            let age = phase["age"] as? Double,
            let percent = phase["phase"] as? Double,
            let illum = phase["illum"] as? Int else {
                
            return nil
        }
        
        let riseInterval = moon["rise"] as? NSTimeInterval ?? 0
        let setInterval = moon["set"] as? NSTimeInterval ?? 0
        
        let rise = NSDate(timeIntervalSince1970: riseInterval)
        let set = NSDate(timeIntervalSince1970: setInterval)
        
        return Moon(phaseName, age, percent, illum, rise, set)
    }
}