//
//  LunarViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct LunarViewModel {
    
    private let model: LunarPhaseModel
    
    init(model: LunarPhaseModel) {
        self.model = model
    }
    
    var phase: String {
        return "ZZ"
    }
    
    var rise: NSDate {
        return NSDate()
    }
    
    var set: NSDate {
        return NSDate()
    }
}