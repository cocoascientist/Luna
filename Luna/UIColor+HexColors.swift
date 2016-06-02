//
//  UIColor+HexColors.swift
//  Luna
//
//  Created by Andrew Shepard on 12/11/14.
//  Copyright (c) 2014 Andrew Shepard. All rights reserved.
//

// http://stackoverflow.com/a/27203691

import UIKit

extension UIColor {
    
    class func hexColor(string: String) -> UIColor {
        let set = NSCharacterSet.whitespacesAndNewlines() as NSCharacterSet
        var colorString = string.trimmingCharacters(in: set).uppercased()
        
        if (colorString.hasPrefix("#")) {
            let index = colorString.index(after: colorString.startIndex)
            colorString = colorString[index..<colorString.endIndex]
        }
        
        if (colorString.characters.count != 6) {
            return UIColor.gray()
        }
        
        var rgbValue: UInt32 = 0
        NSScanner(string: colorString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue:  CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}