//
//  NSDate+Lunar.swift
//  Luna
//
//  Created by Andrew Shepard on 3/23/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

// http://stackoverflow.com/a/27709317

import Foundation

extension Date {
    
    fileprivate var epochJulianDate: Double {
        return 2440587.5
    }
    
    fileprivate var lunarSynodicPeriod: Double {
        return 29.53059
    }
    
    fileprivate var julianDate: Double {
        return epochJulianDate + timeIntervalSince1970 / 86400
    }
    
    var moonPhase: Double {
        let phase = (julianDate + 4.867) / lunarSynodicPeriod
        return (phase - floor(phase))
    }
}
