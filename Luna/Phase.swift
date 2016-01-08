//
//  Phase.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias PhaseResult = Result<Phase>
typealias PhasesResult = Result<[Phase]>

struct Phase {
    let name: String
    let date: NSDate
    
    init(_ name: String, _ date: NSDate) {
        self.name = name
        self.date = date
    }
}

extension Phase {
    static func phaseFromJSON(json: JSON) -> PhaseResult {
        guard
            let name = json["name"] as? String,
            let interval = json["timestamp"] as? NSTimeInterval
        else {
            return .Failure(JSONError.BadJSON)
        }
        
        let date = NSDate(timeIntervalSince1970: interval)
        let phase = Phase(name, date)
        return .Success(phase)
    }
    
    static func phasesFromJSON(json: JSON) -> PhasesResult {
        guard let data = json["response"] as? [JSON] else {
            return .Failure(JSONError.BadJSON)
        }
        
        let results = data.flatMap(Phase.phaseFromJSON)
        let phases = results.flatMap { (phase) -> Phase? in
            switch phase {
            case .Success(let value):
                return value
            case .Failure:
                return nil
            }
        }
        
        return .Success(phases)
    }
}

extension Phase: Equatable { }

func ==(lhs: Phase, rhs: Phase) -> Bool {
    return lhs.date == rhs.date && lhs.name == rhs.name
}
