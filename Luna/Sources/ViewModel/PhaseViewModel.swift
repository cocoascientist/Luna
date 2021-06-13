//
//  PhaseViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import Model
import WeatherIcons
import Formatters

public struct PhaseViewModel {
    
    private let phase: Phase
    
    public init(phase: Phase) {
        self.phase = phase
    }
    
    public var icon: String {
        return phase.name.symbolForMoon
    }
    
    public var date: String {
        return DateFormatter.fullDate.string(from: phase.date)
    }
}

extension PhaseViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(phase.id)
        hasher.combine(phase.name)
    }
}
