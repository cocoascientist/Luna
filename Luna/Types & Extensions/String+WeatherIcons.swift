//
//  String+WeatherIcons.swift
//  Luna
//
//  Created by Andrew Shepard on 1/22/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

extension String {
    
    var symbolForMoon: String {
        switch self {
            
        // Aeris Weather API
        
        case "new moon":
            return "\u{f095}"
        case "first quarter":
            return "\u{f09c}"
        case "full moon":
            return "\u{f0a3}"
        case "last quarter":
            return "\u{f0aa}"
            
        default:
            return "X"
        }
    }
}
