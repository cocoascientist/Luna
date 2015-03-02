//
//  PhasesDataSource.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class PhasesDataSource: NSObject, UITableViewDataSource {
    private var phases: [Phase] = []
    private let model: LunarPhaseModel
    
    weak var tableView: UITableView? {
        didSet {
//            let nib = UINib(nibName: "PhaseTableViewCell", bundle: nil)
//            self.tableView?.registerNib(nib, forCellReuseIdentifier: "Cell")
            self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            
            self.tableView?.dataSource = self
            self.tableView?.reloadData()
        }
    }
    
    init(model: LunarPhaseModel) {
        self.model = model
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "phasesDidUpdate:", name: PhasesDidUpdateNotification, object: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phases.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let phase = self.phases[indexPath.row] as Phase
        cell.textLabel?.text = phase.name
        
        return cell
    }
    
    // MARK: - Private
    
    func phasesDidUpdate(notification: NSNotification) -> Void {
        let result = self.model.currentPhases
        switch result {
        case .Success(let phases):
            self.phases = phases.unbox
            self.tableView?.reloadData()
        case .Failure(let reason):
            println("error updating phases, no data")
        }
    }
}
