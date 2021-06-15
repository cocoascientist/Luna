//
//  Loader.swift
//  Luna
//
//  Created by Andrew Shepard on 7/6/20.
//

import Foundation
import Model

public enum Loader {
    public static func loadPhasesFromJSON() -> [Phase] {
        guard
            let url = Bundle.main.url(forResource: "moonphases", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let phases = try? Phase.decodePhases(from: data)
        else { return [] }
        
        return phases
    }
    
    public static func loadMoonFromJSON() -> Moon {
        guard
            let url = Bundle.main.url(forResource: "sunmoon", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let moon = try? JSONDecoder().decode(Moon.self, from: data)
        else { fatalError() }
        
        return moon
    }
}
