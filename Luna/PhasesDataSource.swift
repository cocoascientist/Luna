//
//  PhasesDataSource.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

private let reuseIdentifier = String(PhaseTableViewCell.self)

class PhasesDataSource: NSObject {
    private var phases: [Phase] = []
    private let model: LunarPhaseModel
    
    private weak var tableView: UITableView? {
        didSet {
            let nib = UINib(nibName: String(PhaseTableViewCell.self), bundle: nil)
            self.tableView?.register(nib, forCellReuseIdentifier: reuseIdentifier)
            
            self.tableView?.dataSource = self
            self.tableView?.reloadData()
        }
    }
    
    init(model: LunarPhaseModel) {
        self.model = model
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhasesDataSource.phasesDidUpdate(_:)), name: NSNotification.Name(rawValue: PhasesDidUpdateNotification), object: nil)
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
    
    func phasesDidUpdate(_ notification: NSNotification) -> Void {
        let result = self.model.currentPhases
        switch result {
        case .success(let phases):
            self.phases = phases
            self.tableView?.reloadData()
        case .failure:
            print("error updating phases, no data")
        }
    }
}

extension PhasesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phases.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let phaseCell = cell as? PhaseTableViewCell {
            phaseCell.viewModel = viewModelForIndexPath(indexPath: indexPath)
            
            if (indexPath as NSIndexPath).row == self.phases.count - 1 {
                cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0)
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)
            }
        }
        
        return cell
    }
}
