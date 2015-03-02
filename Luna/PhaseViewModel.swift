//
//  PhaseViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct PhaseViewModel {
    
    private let phase: Phase
    
    init(phase: Phase) {
        self.phase = phase
    }
    
    var icon: String {
        return phase.name.symbolForMoon()
    }
    
    var date: String {
        return self.formatter.stringFromDate(phase.date)
    }
    
    private var formatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM d yyyy"
        return formatter
    }
}