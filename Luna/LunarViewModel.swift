//
//  LunarViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct LunarViewModel {
    
    private let moon: Moon
    
    init(moon: Moon) {
        self.moon = moon
    }
    
    var icon: String {
        return moon.age.symbolForMoon()
    }
    
    var phase: String {
        return moon.phase.capitalizedString
    }
    
    var rise: String {
        return self.formatter.stringFromDate(moon.rise)
    }
    
    var set: String {
        return self.formatter.stringFromDate(moon.set)
    }
    
    var age: String {
        switch moon.age {
        case 1:
            return "\(moon.age) day old"
        default:
            return "\(moon.age) days old"
        }
    }
    
    var illumination: String {
        return "\(moon.illumination)% illuminated"
    }
    
    private var formatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = NSDateFormatterStyle.LongStyle
        return formatter
    }
}