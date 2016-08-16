//
//  PhasesDataSource.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

private let reuseIdentifier = String(describing: PhaseTableViewCell.self)

class PhasesDataSource: NSObject {
    fileprivate var phases: [Phase] = []
    fileprivate let model: LunarPhaseModel
    
    fileprivate weak var tableView: UITableView? {
        didSet {
            let nib = UINib(nibName: String(describing: PhaseTableViewCell.self), bundle: nil)
            self.tableView?.register(nib, forCellReuseIdentifier: reuseIdentifier)
            
            self.tableView?.dataSource = self
            self.tableView?.reloadData()
        }
    }
    
    init(model: LunarPhaseModel) {
        self.model = model
        super.init()
        
        let name = NSNotification.Name(rawValue: "PhasesDidUpdateNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(PhasesDataSource.phasesDidUpdate(with:)), name: name, object: nil)
    }
    
    func configure(using tableView: UITableView) -> Void {
        self.tableView = tableView
    }
    
    // MARK: - Private
    
    func viewModel(for indexPath: IndexPath) -> PhaseViewModel {
        let phase = self.phases[indexPath.row]
        let viewModel = PhaseViewModel(phase: phase)
        return viewModel
    }
    
    internal func phasesDidUpdate(with notification: Notification) -> Void {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let phaseCell = cell as? PhaseTableViewCell {
            phaseCell.viewModel = viewModel(for: indexPath)
            
            if indexPath.row == self.phases.count - 1 {
                cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0)
            } else {
                cell.separatorInset = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)
            }
        }
        
        return cell
    }
}
