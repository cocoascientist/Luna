//
//  LunarPhaseView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/23/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

// http://www.codeproject.com/Articles/100174/Calculate-and-Draw-Moon-Phase

import UIKit

@IBDesignable
class LunarPhaseView: UIView {
    let date: NSDate
    
    init(frame: CGRect, date: NSDate) {
        self.date = date
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    override init(frame: CGRect) {
        self.date = NSDate()
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.date = NSDate()
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let phase = self.date.moonPhase()
        let diameter = Double(CGRectGetWidth(rect))
        let radius = Int(diameter / 2)
        
        for Ypos in 0...radius {
            let Xpos = sqrt(Double((radius * radius) - Ypos*Ypos))
            
            let pB1 = CGPointMake(CGFloat(Double(radius)-Xpos), CGFloat(Double(Ypos)+Double(radius)))
            let pB2 = CGPointMake(CGFloat(Xpos+Double(radius)), CGFloat(Double(Ypos)+Double(radius)))
            
            let pB3 = CGPointMake(CGFloat(Double(radius)-Xpos), CGFloat(Double(radius)-Double(Ypos)))
            let pB4 = CGPointMake(CGFloat(Xpos+Double(radius)), CGFloat(Double(radius)-Double(Ypos)))
            
            let path = UIBezierPath()
            path.moveToPoint(pB1)
            path.addLineToPoint(pB2)
            
            path.moveToPoint(pB3)
            path.addLineToPoint(pB4)
            
            UIColor.blackColor().setStroke()
            path.stroke()
            
            let Rpos = 2 * Xpos
            var Xpos1 = 0.0
            var Xpos2 = 0.0
            if (phase < 0.5) {
                Xpos1 = Xpos * -1
                Xpos2 = Double(Rpos) - (2.0 * phase * Double(Rpos)) - Double(Xpos)
            }
            else {
                Xpos1 = Xpos;
                Xpos2 = Double(Xpos) - (2.0 * phase * Double(Rpos)) + Double(Rpos)
            }
            
            let pW1 = CGPointMake(CGFloat(Xpos1+Double(radius)), CGFloat(Double(radius)-Double(Ypos)))
            let pW2 = CGPointMake(CGFloat(Xpos2+Double(radius)), CGFloat(Double(radius)-Double(Ypos)))
            let pW3 = CGPointMake(CGFloat(Xpos1+Double(radius)), CGFloat(Double(Ypos)+Double(radius)))
            let pW4 = CGPointMake(CGFloat(Xpos2+Double(radius)), CGFloat(Double(Ypos)+Double(radius)))
            
            let path2 = UIBezierPath()
            path2.moveToPoint(pW1)
            path2.addLineToPoint(pW2)
            
            path2.moveToPoint(pW3)
            path2.addLineToPoint(pW4)
            
            UIColor.whiteColor().setStroke()
            path2.lineWidth = 2.0
            path2.stroke()
        }
    }
}
