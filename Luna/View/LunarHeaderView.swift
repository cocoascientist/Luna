//
//  LunarHeaderView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

final class LunarHeaderView: UIView {

    @IBOutlet var phaseView: LunarPhaseView!
    @IBOutlet var phaseNameLabel: UILabel!
    
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var illuminationLabel: UILabel!
    
    @IBOutlet var riseLabel: UILabel!
    @IBOutlet var setLabel: UILabel!
    
    var viewModel: LunarViewModel? {
        didSet {
            self.riseLabel.text = viewModel?.rise
            self.setLabel.text = viewModel?.set
            
            self.ageLabel.text = viewModel?.age
            self.illuminationLabel.text = viewModel?.illumination
            
            if let phase = viewModel?.phase {
                guard let font = UIFont(name: "EuphemiaUCAS", size: 38.0) else { fatalError() }
                let color = UIColor.white
                let attributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
                self.phaseNameLabel.attributedText = NSAttributedString(string: phase, attributes: attributes)
            }
            
            UIView.animate(withDuration: 0.5) { 
                self.phaseView.alpha = 1.0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.phaseView.alpha = 0.0
        self.phaseNameLabel.text = NSLocalizedString("Loading...", comment: "Loading...")
        self.ageLabel.text = ""
        self.illuminationLabel.text = ""
        self.riseLabel.text = ""
        self.setLabel.text = ""
        
        self.phaseNameLabel.textColor = UIColor.white
        self.ageLabel.textColor = UIColor.white
        self.illuminationLabel.textColor = UIColor.white
        self.riseLabel.textColor = UIColor.white
        self.setLabel.textColor = UIColor.white
        
        self.backgroundColor = UIColor.clear
    }

}
