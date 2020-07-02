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
        return phase.name.symbolForMoon
    }
    
    var date: String {
        return DateFormatter.fullDate.string(from: phase.date)
    }
}

extension PhaseViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(phase.id)
        hasher.combine(phase.name)
    }
}
