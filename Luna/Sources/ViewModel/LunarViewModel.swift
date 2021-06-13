//
//  LunarViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import Model

public struct LunarViewModel {
    
    private let moon: Moon
    
    public init(moon: Moon) {
        self.moon = moon
    }
    
    public var icon: String {
        return moon.percent.symbolForMoon
    }
    
    public var phase: String {
        return moon.phase.capitalized
    }
    
    public var rise: String {
        guard let rise = moon.rise else { return "---" }
        return DateFormatter.fullDate.string(from: rise)
    }
    
    public var set: String {
        guard let set = moon.set else { return  "---" }
        return DateFormatter.fullDate.string(from: set)
    }
    
    public var age: String {
        let length = 27.3
        let age = ((moon.percent * 0.01) * length) * 100.0
        
        switch age {
        case 1:
            let day = String(format: "%.1f", age)
            return "\(day) day old"
        default:
            let days = String(format: "%.1f", age)
            return "\(days) days old"
        }
    }
    
    public var illumination: String {
        let percent = String(format: "%.1f", moon.percent * 100)
        return "\(percent)% complete"
    }
}
