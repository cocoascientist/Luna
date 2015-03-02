//
//  Phase.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct Phase {
    let name: String
    let date: NSDate
}

extension Phase {
    static func phaseFromJSON(json: JSON) -> Phase? {
        if let name = json["name"] as? String,
            let interval = json["timestamp"] as? NSTimeInterval {
                return Phase(name: name, date: NSDate(timeIntervalSince1970: interval))
        }
        
        return nil
    }
    
    static func phasesFromJSON(json: JSON) -> [Phase]? {
        var phases: [Phase]? = nil
        if let data = json["response"] as? [JSON] {
            phases = []
            for obj in data {
                if let phase = self.phaseFromJSON(obj) {
                    phases?.append(phase)
                }
            }
        }
        
        return phases
    }
}

