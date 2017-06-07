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

private struct PhaseWrapper: Codable {
    let phases: [Phase]
    
    private enum CodingKeys: String, CodingKey {
        case error
        case success
        case response
    }
    
    private enum PhaseKeys: String, CodingKey {
        case name
        case timestamp
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError("encoding not supported")
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let success = try container.decode(Bool.self, forKey: .success)
        guard success == true else { throw CocoaError(.coderInvalidValue) }
        
        var responseContainer = try container.nestedUnkeyedContainer(forKey: .response)
        
        var phases: [Phase] = []
        while !responseContainer.isAtEnd {
            let phaseContainer = try responseContainer.nestedContainer(keyedBy: PhaseKeys.self)
            
            let name = try phaseContainer.decode(String.self, forKey: .name)
            let timestamp = try phaseContainer.decode(TimeInterval.self, forKey: .timestamp)
            let date = Date(timeIntervalSince1970: timestamp)
            
            let phase = Phase(name: name, date: date)
            phases.append(phase)
        }
        
        self.phases = phases
    }
}

struct Phase {
    let name: String
    let date: Date
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
}

func PhasesResultFromData(_ data: Data) -> PhasesResult {
    let decoder = JSONDecoder()
    
    do {
        let wrapper = try decoder.decode(PhaseWrapper.self, from: data)
        return PhasesResult.success(wrapper.phases)
    } catch (let error) {
        return PhasesResult.failure(error)
    }
}

extension Phase: Equatable { }

func ==(lhs: Phase, rhs: Phase) -> Bool {
    return lhs.date == rhs.date && lhs.name == rhs.name
}
