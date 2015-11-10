//
//  ViewController.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

let myContext = UnsafeMutablePointer<Void>()

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var model: LunarPhaseModel!
    
    override func awakeFromNib() {
        self.model = LunarPhaseModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private lazy var dataSource: PhasesDataSource = {
        return PhasesDataSource(model: self.model)
    }()
    
    private lazy var headerView: LunarHeaderView = {
        let nib = NSBundle.mainBundle().loadNibNamed(LunarHeaderView.nibName, owner: self, options: nil)
        guard let headerView = nib.first as? LunarHeaderView else {
            fatalError("Could not load LunarHeaderView from nib")
        }
        
        let insetY: CGFloat = (self.traitCollection.userInterfaceIdiom == .Pad) ? 200.0 : 0.0
        headerView.frame = CGRectInset(UIScreen.mainScreen().bounds, 0.0, insetY)
        
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.pagingEnabled = true
        self.tableView.rowHeight = 44.0
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.hexColor("232526").CGColor, UIColor.hexColor("414345").CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        self.view.backgroundColor = UIColor.redColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.lightGrayColor()
        
        self.dataSource.configureUsing(self.tableView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "modelDidUpdate:", name: MoonDidUpdateNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveError:", name: LunarModelDidReceiveErrorNotification, object: nil)
        
        self.model.addObserver(self, forKeyPath: "loading", options: NSKeyValueObservingOptions.New, context: myContext)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.tableHeaderView = self.headerView
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if self.model == object as? LunarPhaseModel && keyPath == "loading" && context == myContext {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = self.model.loading
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: - Update Handlers

    func didReceiveError(notification: NSNotification) -> Void {
        if let message = notification.userInfo?["Error"] as? String {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alertController.addAction(action)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            print("Error: Unhandled notification: \(notification.userInfo)")
            
        }
        
        self.headerView.phaseNameLabel.text = "Error"
    }
    
    func modelDidUpdate(notification: NSNotification) -> Void {
        self.updateLunarViewModel()
    }
    
    func updateLunarViewModel() -> Void {
        let result = self.model.currentMoon
        
        switch result {
        case .Success(let moon):
            self.headerView.viewModel = LunarViewModel(moon: moon)
        case .Failure:
            print("error updating view model, no data")
        }
    }
}
