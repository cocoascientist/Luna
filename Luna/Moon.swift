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
//    let percent: Double
//    
//    let age: Double
//    let angle: Double
//    let illumination: Double
    
    let rise: NSDate
    let set: NSDate
}

struct Sun {
    let rise: NSDate
    let set: NSDate
}

extension Moon {
    static func moonFromJSON(json: JSON) -> Moon? {
        
        if let response = json["response"] as? [JSON],
            let moon = response.first?["moon"] as? JSON,
            let rise = moon["rise"] as? NSTimeInterval,
            let set = moon["set"] as? NSTimeInterval,
            let phase = moon["phase"] as? JSON,
            let name = phase["name"] as? String {

                return Moon(phase: name,
                    rise: NSDate(timeIntervalSince1970: rise),
                    set: NSDate(timeIntervalSince1970: set))
        }
        
        return nil
    }
}