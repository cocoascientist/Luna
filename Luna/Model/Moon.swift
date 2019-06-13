//
//  Luna.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import SwiftUI

struct Moon: Codable, Identifiable {
    var id: UUID = UUID()
    
    let phase: String
    let age: Double
    let percent: Double
    
    let illumination: Int
    
    let rise: Date?
    let set: Date?
    
    private enum CodingKeys: String, CodingKey {
        case error
        case response
        case success
    }
    
    private enum ResponseKeys: String, CodingKey {
        case timestamp
        case moon
    }
    
    private enum MoonKeys: String, CodingKey {
        case rise
        case set
        case phase
    }
    
    private enum PhaseKeys: String, CodingKey {
        case age
        case angle
        case name
        case percent = "phase"
        case illumination = "illum"
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError("encoding not supported")
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let success = try container.decode(Bool.self, forKey: .success)
        guard success == true else { throw CocoaError(.coderInvalidValue) }
        
        var responseContainer = try container.nestedUnkeyedContainer(forKey: .response)
        let response = try responseContainer.nestedContainer(keyedBy: ResponseKeys.self)
        let moonContainer = try response.nestedContainer(keyedBy: MoonKeys.self, forKey: .moon)
        let phaseContainer = try moonContainer.nestedContainer(keyedBy: PhaseKeys.self, forKey: .phase)
        
        let rise = try? moonContainer.decode(TimeInterval.self, forKey: .rise)
        let set = try? moonContainer.decode(TimeInterval.self, forKey: .set)
        let age = try phaseContainer.decode(Double.self, forKey: .age)
        let name = try phaseContainer.decode(String.self, forKey: .name)
        let illumination = try phaseContainer.decode(Int.self, forKey: .illumination)
        let percent = try phaseContainer.decode(Double.self, forKey: .percent)
        
        self.phase = name
        self.age = age
        self.percent = percent
        self.illumination = illumination
        
        if let rise = rise {
            self.rise = Date(timeIntervalSince1970: rise)
        } else {
            self.rise = nil
        }
        
        if let set = set {
            self.set = Date(timeIntervalSince1970: set)
        } else {
            self.set = nil
        }
    }
}

extension Moon: Equatable { }

func ==(lhs: Moon, rhs: Moon) -> Bool {
    return lhs.phase == rhs.phase && lhs.age == rhs.age &&
           lhs.rise == lhs.rise && lhs.set == lhs.set
}
