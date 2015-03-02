//
//  ViewController.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private lazy var headerView: LunarHeaderView? = {
        let nib = NSBundle.mainBundle().loadNibNamed(LunarHeaderView.nibName, owner: self, options: nil)
        if let headerView = nib.first as? LunarHeaderView {
            headerView.frame = UIScreen.mainScreen().bounds
            
            let model = LunarPhaseModel()
            headerView.viewModel = LunarViewModel(model: model)
            
            return headerView
        }
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.tableHeaderView = self.headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

