//
//  ViewController.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

let myContext = UnsafeMutablePointer<Void>(nil)

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var model: LunarPhaseModel!
    
    var shouldPresentAlert: Bool = true
    
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
        let nib = NSBundle.main().loadNibNamed(String(LunarHeaderView), owner: self, options: nil)
        guard let headerView = nib.first as? LunarHeaderView else {
            fatalError("Could not load LunarHeaderView from nib")
        }
        
        let insetY: CGFloat = (self.traitCollection.userInterfaceIdiom == .pad) ? 200.0 : 0.0
        headerView.frame = CGRectInset(UIScreen.main().bounds, 0.0, insetY)
        
        return headerView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        let action = #selector(ViewController.handleRefresh(_:))
        control.addTarget(self, action: action, for: UIControlEvents.valueChanged)
        control.backgroundColor = UIColor.clear()
        control.tintColor = UIColor.white()
        
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.isPagingEnabled = true
        self.tableView.rowHeight = 44.0
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.hexColor("232526").cgColor, UIColor.hexColor("414345").cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.tableView.backgroundColor = UIColor.clear()
        self.tableView.separatorColor = UIColor.lightGray()
        self.tableView.addSubview(refreshControl)
        
        self.dataSource.configureUsing(tableView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.modelDidUpdate(_:)), name: MoonDidUpdateNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didReceiveError(_:)), name: LunarModelDidReceiveErrorNotification, object: nil)
        
        self.model.addObserver(self, forKeyPath: "loading", options: NSKeyValueObservingOptions.new, context: myContext)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.tableHeaderView = self.headerView
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if self.model == object as? LunarPhaseModel && keyPath == "loading" && context == myContext {
            UIApplication.shared().isNetworkActivityIndicatorVisible = self.model.loading
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Update Handlers
    
    func handleRefresh(sender: AnyObject) {
        self.model.applicationDidResume(NSNotification())
    }

    func didReceiveError(notification: NSNotification) -> Void {
        if let message = notification.userInfo?["message"] as? String,
            let title = notification.userInfo?["title"] as? String {
            
            self.showAlert(title, message)
            
            self.headerView.phaseNameLabel.text = title
        }
        else {
            print("Error: Unhandled notification: \(notification.userInfo)")
            
            self.headerView.phaseNameLabel.text = "Error"
        }
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
    
    func showAlert(title: String, _ message: String) {
        dispatch_async(dispatch_get_main_queue()) { 
            if self.shouldPresentAlert {
                self.shouldPresentAlert = false
                
//                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//                
//                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                    self.shouldPresentAlert = true
//                })
//                
//                alertController.addAction(action)
//                
//                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}