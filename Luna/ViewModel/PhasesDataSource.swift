//
//  PhasesDataSource.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = String(describing: PhaseTableViewCell.self)

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
        
        let name = Notification.Name.didUpdatePhases
        let selector = #selector(PhasesDataSource.phasesDidUpdate(with:))
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    public func configure(using tableView: UITableView) -> Void {
        self.tableView = tableView
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
                cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            }
        }
        
        return cell
    }
}

extension PhasesDataSource {
    fileprivate func viewModel(for indexPath: IndexPath) -> PhaseViewModel {
        let phase = self.phases[indexPath.row]
        let viewModel = PhaseViewModel(phase: phase)
        return viewModel
    }
    
    @objc internal func phasesDidUpdate(with notification: Notification) -> Void {
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
