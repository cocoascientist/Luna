//
//  PhasesDataSource.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

private let reuseIdentifier = String(PhaseTableViewCell)

class PhasesDataSource: NSObject {
    private var phases: [Phase] = []
    private let model: LunarPhaseModel
    
    private weak var tableView: UITableView? {
        didSet {
            let nib = UINib(nibName: String(PhaseTableViewCell), bundle: nil)
            self.tableView?.register(nib, forCellReuseIdentifier: reuseIdentifier)
            
            self.tableView?.dataSource = self
            self.tableView?.reloadData()
        }
    }
    
    init(model: LunarPhaseModel) {
        self.model = model
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhasesDataSource.phasesDidUpdate(_:)), name: PhasesDidUpdateNotification, object: nil)
    }
    
    func configureUsing(tableView: UITableView) -> Void {
        self.tableView = tableView
    }
    
    // MARK: - Private
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> PhaseViewModel {
        let phase = self.phases[indexPath.row] as Phase
        let viewModel = PhaseViewModel(phase: phase)
        return viewModel
    }
    
    func phasesDidUpdate(notification: NSNotification) -> Void {
        let result = self.model.currentPhases
        switch result {
        case .Success(let phases):
            self.phases = phases
            self.tableView?.reloadData()
        case .Failure:
            print("error updating phases, no data")
        }
    }
}

extension PhasesDataSource: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phases.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:)
    func tableView(tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let phaseCell = cell as? PhaseTableViewCell {
            phaseCell.viewModel = viewModelForIndexPath(indexPath)
            
            if indexPath.row == self.phases.count - 1 {
                cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0)
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)
            }
        }
        
        return cell
    }
}