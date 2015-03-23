//
//  Double+WeatherIcons.swift
//  Luna
//
//  Created by Andrew Shepard on 3/3/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

extension Double {
    func symbolForMoon() -> String {
        let length = 27.3
        let age = round(((self * 0.01) * length) * 100.0)
        
        switch Int(age) {
        case 0, 27:
            return "\u{f095}" // new moon
        case 1:
            return "\u{f096}"
        case 2:
            return "\u{f097}"
        case 3:
            return "\u{f098}"
        case 4:
            return "\u{f099}"
        case 5:
            return "\u{f09a}"
        case 6:
            return "\u{f09b}"
        case 7:
            return "\u{f09c}" // first quarter
        case 8:
            return "\u{f09d}"
        case 9:
            return "\u{f09e}"
        case 10:
            return "\u{f09f}"
        case 11:
            return "\u{f0a0}"
        case 12:
            return "\u{f0a1}"
        case 13:
            return "\u{f0a2}"
        case 14:
            return "\u{f0a3}" // full moon
        case 15:
            return "\u{f0a4}"
        case 16:
            return "\u{f0a5}"
        case 17:
            return "\u{f0a6}"
        case 18:
            return "\u{f0a7}"
        case 19:
            return "\u{f0a8}"
        case 20:
            return "\u{f0a9}"
        case 21:
            return "\u{f0aa}" // third quarter
        case 22:
            return "\u{f0ab}"
        case 23:
            return "\u{f0ac}"
        case 24:
            return "\u{f0ad}"
        case 25:
            return "\u{f0ae}"
        case 26:
            return "\u{f0af}"
        case 26:
            return "\u{f0b0}"
        default:
            return "X"
        }
    }
}