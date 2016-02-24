//
//  Luna.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias MoonResult = Result<Moon>

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

extension Moon: JSONConstructable {
    
    init?(json: JSON) {
        guard
            let response = json["response"] as? [JSON],
            let moonObj = response.first?["moon"] as? JSON,
            let phase = moonObj["phase"] as? JSON,
            let phaseName = phase["name"] as? String,
            let age = phase["age"] as? Double,
            let percent = phase["phase"] as? Double,
            let illum = phase["illum"] as? Int
            else {
                return nil
        }
        
        let riseInterval = moonObj["rise"] as? Double ?? 0
        let setInterval = moonObj["set"] as? Double ?? 0
        
        let rise = NSDate(timeIntervalSince1970: riseInterval)
        let set = NSDate(timeIntervalSince1970: setInterval)
        
        self.phase = phaseName
        self.age = age
        self.percent = percent
        self.illumination = illum
        self.rise = rise
        self.set = set
    }
}

extension Moon {
    static func moonFromJSON(json: JSON) -> MoonResult {
        if let moon = Moon.init(json: json) {
            return MoonResult.Success(moon)
        } else {
            return MoonResult.Failure(JSONError.BadFormat)
        }
    }
}

extension Moon: Equatable { }

func ==(lhs: Moon, rhs: Moon) -> Bool {
    return lhs.phase == rhs.phase && lhs.age == rhs.age &&
           lhs.rise == lhs.rise && lhs.set == lhs.set
}
