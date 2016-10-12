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
    let date: Date
}

extension Phase: JSONConstructable {
    init?(json: JSON) {
        guard
            let name = json["name"] as? String,
            let interval = json["timestamp"] as? TimeInterval
        else {
            return nil
        }
        
        self.name = name
        self.date = Date(timeIntervalSince1970: interval)
    }
}

extension Phase {
    static func phase(from json: JSON) -> PhaseResult {
        if let phase = Phase(json: json) {
            return .success(phase)
        } else {
            return .failure(PhaseModelError.noPhases)
        }
    }
    
    static func phases(from json: JSON) -> PhasesResult {
        guard let data = json["response"] as? [JSON] else {
            return .failure(JSONError.badFormat)
        }
        
        let results = data.flatMap(Phase.phase)
        let phases = results.flatMap { (phase) -> Phase? in
            switch phase {
            case .success(let value):
                return value
            case .failure:
                return nil
            }
        }
        
        return .success(phases)
    }
}

extension Phase: Equatable { }

func ==(lhs: Phase, rhs: Phase) -> Bool {
    return lhs.date == rhs.date && lhs.name == rhs.name
}
