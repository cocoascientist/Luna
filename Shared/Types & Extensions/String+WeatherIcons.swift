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
            return "circle.fill"
        case "first quarter":
            return "circle.lefthalf.fill"
        case "full moon":
            return "circle"
        case "last quarter":
            return "circle.righthalf.fill"
            
        default:
            return "X"
        }
    }
}
