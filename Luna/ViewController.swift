//
//  ViewController.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

fileprivate let _context = UnsafeMutableRawPointer(bitPattern: 0)

final class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var model: LunarPhaseModel!
    
    fileprivate var shouldPresentAlert: Bool = true
    
    override func awakeFromNib() {
        self.model = LunarPhaseModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate lazy var dataSource: PhasesDataSource = {
        return PhasesDataSource(model: self.model)
    }()
    
    fileprivate lazy var headerView: LunarHeaderView = {
        let nib = Bundle.main.loadNibNamed("LunarHeaderView", owner: self, options: nil)
        guard let headerView = nib?.first as? LunarHeaderView else {
            fatalError("Could not load LunarHeaderView from nib")
        }
        
        let insetY: CGFloat = (self.traitCollection.userInterfaceIdiom == .pad) ? 200.0 : 0.0
        headerView.frame = UIScreen.main.bounds.insetBy(dx: 0.0, dy: insetY)
        
        return headerView
    }()
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        let action = #selector(ViewController.handleRefresh(_:))
        control.addTarget(self, action: action, for: UIControlEvents.valueChanged)
        control.backgroundColor = UIColor.clear
        control.tintColor = UIColor.white
        
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
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorColor = UIColor.lightGray
//        self.tableView.addSubview(refreshControl)
        
        self.dataSource.configure(using: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.modelDidUpdate(_:)), name: .didUpdateMoon, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError(_:)), name: .didReceiveLunarModelError, object: nil)
        
        self.model.addObserver(self, forKeyPath: "loading", options: .new, context: _context)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.tableHeaderView = self.headerView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.model == object as? LunarPhaseModel && keyPath == "loading" && context == _context {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.model.loading
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Update Handlers
    
    @objc internal func handleRefresh(_ sender: AnyObject) {
        // TODO: implement
    }

    @objc internal func didReceiveError(_ notification: Notification) -> Void {
        if let message = notification.userInfo?["message"] as? String,
            let title = notification.userInfo?["title"] as? String {
            
            self.showAlert(title, message)
            
            self.headerView.phaseNameLabel.text = title
        }
        else {
            print("Error: Unhandled notification: \(notification)")
            self.headerView.phaseNameLabel.text = NSLocalizedString("Error", comment: "Error")
        }
    }
    
    @objc internal func modelDidUpdate(_ notification: Notification) -> Void {
        self.updateLunarViewModel()
    }
    
    fileprivate func updateLunarViewModel() -> Void {
        let result = self.model.currentMoon
        
        switch result {
        case .success(let moon):
            self.headerView.viewModel = LunarViewModel(moon: moon)
        case .failure:
            print("error updating view model, no data")
        }
    }
    
    fileprivate func showAlert(_ title: String, _ message: String) {
        
        DispatchQueue.main.async { 
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
