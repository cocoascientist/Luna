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
        
        if let response = json["response"] as? [JSON],
            moon = response.first?["moon"] as? JSON,
            riseInterval = moon["rise"] as? NSTimeInterval,
            setInterval = moon["set"] as? NSTimeInterval,
            phase = moon["phase"] as? JSON,
            phaseName = phase["name"] as? String,
            age = phase["age"] as? Double,
            percent = phase["phase"] as? Double,
            illum = phase["illum"] as? Int {
                
                let rise = NSDate(timeIntervalSince1970: riseInterval)
                let set = NSDate(timeIntervalSince1970: setInterval)
                return Moon(phaseName, age, percent, illum, rise, set)
        }
        
        return nil
    }
}