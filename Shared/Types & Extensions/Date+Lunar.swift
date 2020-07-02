//
//  Date+Lunar.swift
//  Luna
//
//  Created by Andrew Shepard on 3/23/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

// http://stackoverflow.com/a/27709317

import Foundation

extension Date {
    private var julianDate: Double {
        let epochJulianDate = 2440587.5
        return epochJulianDate + timeIntervalSince1970 / 86400
    }
    
    var moonPhase: Double {
        let lunarSynodicPeriod = 29.53059
        let phase = (julianDate + 4.867) / lunarSynodicPeriod
        return (phase - floor(phase))
    }
}
