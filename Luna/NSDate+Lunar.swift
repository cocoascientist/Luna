//
//  NSDate+Lunar.swift
//  Luna
//
//  Created by Andrew Shepard on 3/23/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

// http://stackoverflow.com/a/27709317

import Foundation

extension NSDate {
    
    private func epochJulianDate() -> Double {
        return 2440587.5
    }
    
    private func lunarSynodicPeriod() -> Double {
        return 29.53059
    }
    
    private func julianDate() -> Double {
        return epochJulianDate() + self.timeIntervalSince1970 / 86400
    }
    
    func moonPhase() -> Double {
        let phase = (self.julianDate() + 4.867) / self.lunarSynodicPeriod()
        return (phase - floor(phase))
    }
}