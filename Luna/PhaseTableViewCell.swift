//
//  PhaseTableViewCell.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

public class PhaseTableViewCell: UITableViewCell {
    
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var viewModel: PhaseViewModel? {
        didSet {
            self.iconLabel.text = viewModel?.icon
            self.dateLabel.text = viewModel?.date
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.iconLabel.text = ""
        self.dateLabel.text = ""
        
        self.iconLabel.textColor = UIColor.whiteColor()
        self.dateLabel.textColor = UIColor.whiteColor()
        
        self.iconLabel.font = UIFont(name: "Weather Icons", size: 32.0)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
