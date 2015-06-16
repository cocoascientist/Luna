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
    
    init(_ name: String, _ date: NSDate) {
        self.name = name
        self.date = date
    }
}

extension Phase {
    static func phaseFromJSON(json: JSON) -> Phase? {
        guard
            let name = json["name"] as? String,
            let interval = json["timestamp"] as? NSTimeInterval else {
            return nil
        }
        
        let date = NSDate(timeIntervalSince1970: interval)
        return Phase(name, date)
    }
    
    static func phasesFromJSON(json: JSON) -> [Phase]? {
        guard let data = json["response"] as? [JSON] else {
            return []
        }
        
        var phases: [Phase] = []
        for obj in data {
            if let phase = self.phaseFromJSON(obj) {
                phases.append(phase)
            }
        }
        
        return phases
    }
}

