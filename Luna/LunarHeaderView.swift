//
//  LunarHeaderView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class LunarHeaderView: UIView {

    @IBOutlet var phaseLabel: UILabel!
    
    var viewModel: LunarViewModel? {
        didSet {
            self.phaseLabel.text = viewModel?.phase
        }
    }
    
    class var nibName: String {
        return "LunarHeaderView"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.phaseLabel.text = "X"
        
//        let font = UIFont(name: "Weather Icons", size: 40.0)
    }

}
