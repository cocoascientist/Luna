//
//  LunarHeaderView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class LunarHeaderView: UIView {

    @IBOutlet var phaseIconLabel: UILabel!
    @IBOutlet var phaseNameLabel: UILabel!
    
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var illuminationLabel: UILabel!
    
    @IBOutlet var riseLabel: UILabel!
    @IBOutlet var setLabel: UILabel!
    
    class var nibName: String {
        return "LunarHeaderView"
    }
    
    var viewModel: LunarViewModel? {
        didSet {
            self.phaseIconLabel.text = viewModel?.icon
            
            self.riseLabel.text = viewModel?.rise
            self.setLabel.text = viewModel?.set
            
            self.ageLabel.text = viewModel?.age
            self.illuminationLabel.text = viewModel?.illumination
            
            if let phase = viewModel?.phase {
                let font = UIFont(name: "EuphemiaUCAS", size: 38.0)!
                let color = UIColor.whiteColor()
                let attributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
                self.phaseNameLabel.attributedText = NSAttributedString(string: phase, attributes: attributes)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.phaseIconLabel.font = UIFont(name: "Weather Icons", size: 200.0)
        
        self.phaseIconLabel.text = ""
        self.phaseNameLabel.text = ""
        self.ageLabel.text = ""
        self.illuminationLabel.text = ""
        self.riseLabel.text = ""
        self.setLabel.text = ""
        
        self.phaseIconLabel.textColor = UIColor.whiteColor()
        self.phaseNameLabel.textColor = UIColor.whiteColor()
        self.ageLabel.textColor = UIColor.whiteColor()
        self.illuminationLabel.textColor = UIColor.whiteColor()
        self.riseLabel.textColor = UIColor.whiteColor()
        self.setLabel.textColor = UIColor.whiteColor()
        
        self.backgroundColor = UIColor.clearColor()
    }

}
