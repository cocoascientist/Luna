//
//  PhaseViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct PhaseViewModel {
    
    fileprivate let phase: Phase
    
    init(phase: Phase) {
        self.phase = phase
    }
    
    var icon: String {
        return phase.name.symbolForMoon
    }
    
    var date: String {
        return self.formatter.string(from: phase.date)
    }
    
    fileprivate var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy 'at' h:mm a z"
        return formatter
    }
}
