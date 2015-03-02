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
    
    var viewModel: LunarViewModel? {
        didSet {
            self.phaseIconLabel.text = viewModel?.icon
            self.phaseNameLabel.text = viewModel?.phase            
        }
    }
    
    class var nibName: String {
        return "LunarHeaderView"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.phaseIconLabel.font = UIFont(name: "Weather Icons", size: 200.0)
        
        self.phaseIconLabel.text = ""
        self.phaseNameLabel.text = ""
    }

}
