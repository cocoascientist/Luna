//
//  PhaseTableViewCell.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

final class PhaseTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var iconLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var viewModel: PhaseViewModel? {
        didSet {
            self.iconLabel.text = viewModel?.icon
            self.dateLabel.text = viewModel?.date
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.iconLabel.text = ""
        self.dateLabel.text = ""
        
        self.iconLabel.textColor = .white
        self.dateLabel.textColor = .white
        
        self.iconLabel.font = UIFont(name: "Weather Icons", size: 32.0)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.iconLabel.text = ""
        self.dateLabel.text = ""
    }
}
