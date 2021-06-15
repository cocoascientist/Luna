//
//  Phase.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import SwiftUI

public struct Phase: Decodable, Identifiable {
    public var id: UUID = UUID()
    public let name: String
    public let date: Date
    
    private enum CodingKeys: String, CodingKey {
        case name
        case timestamp
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
        let date = Date(timeIntervalSince1970: timestamp)
        
        self.name = name
        self.date = date
    }
}

extension Phase {
    public static func decodePhases(from data: Data) throws -> [Phase] {
        let decoder = JSONDecoder()
        
        let list = try decoder.decode(PhaseList.self, from: data)
        return list.phases
    }
}

extension Phase: Equatable { }

public func ==(lhs: Phase, rhs: Phase) -> Bool {
    return lhs.date == rhs.date && lhs.name == rhs.name
}

private struct PhaseList: Decodable {
    let phases: [Phase]
    
    private enum CodingKeys: String, CodingKey {
        case success
        case response
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let success = try container.decode(Bool.self, forKey: .success)
        guard success == true else { throw CocoaError(.coderInvalidValue) }
        
        let phases = try container.decode([Phase].self, forKey: .response)
        self.phases = phases
    }
}
