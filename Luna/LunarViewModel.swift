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
        return moon.age.symbolForCurrentPhase()
    }
    
    var phase: String {
        return moon.phase
    }
    
    var rise: NSDate {
        return moon.rise
    }
    
    var set: NSDate {
        return moon.set
    }
}