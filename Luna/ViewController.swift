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
    
    private let model = LunarPhaseModel()
    
    private lazy var headerView: LunarHeaderView? = {
        let nib = NSBundle.mainBundle().loadNibNamed(LunarHeaderView.nibName, owner: self, options: nil)
        if let headerView = nib.first as? LunarHeaderView {
            headerView.frame = UIScreen.mainScreen().bounds
            return headerView
        }
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "modelDidUpdate:", name: LunarModelDidUpdateNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveError:", name: LunarModelDidReceiveErrorNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.tableHeaderView = self.headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private

    func didReceiveError(notification: NSNotification) -> Void {
        // TODO: add end user error handling
        println("error notification: \(notification.userInfo)")
    }
    
    func modelDidUpdate(notification: NSNotification) -> Void {
        self.updateLunarViewModel()
    }
    
    func updateLunarViewModel() -> Void {
        let result = self.model.currentMoon
        
        switch result {
        case .Success(let moon):
            let viewModel = LunarViewModel(moon: moon.unbox)
            self.headerView?.viewModel = viewModel
        case .Failure(let reason):
            println("error updating view model, no data")
        }
    }
}

