//
//  LunarViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct LunarViewModel {
    
    private let moon: Moon
    
    init(moon: Moon) {
        self.moon = moon
    }
    
    var icon: String {
        return moon.percent.symbolForMoon
    }
    
    var phase: String {
        return moon.phase.capitalized
    }
    
    var rise: String {
        guard let rise = moon.rise else { return "---" }
        return self.formatter.string(from: rise)
    }
    
    var set: String {
        guard let set = moon.set else { return  "---" }
        return self.formatter.string(from: set)
    }
    
    var age: String {
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
    
    var illumination: String {
        let percent = String(format: "%.1f", moon.percent * 100)
        return "\(percent)% complete"
    }
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy 'at' h:mm a z"
        return formatter
    }
}
