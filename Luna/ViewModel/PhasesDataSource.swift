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
    private var phases: [Phase] = []
    private let model: LunarPhaseModel
    
    private weak var tableView: UITableView? {
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
            
            let leftInset = (indexPath.row == phases.count - 1) ?
                cell.bounds.size.width : 16.0
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: leftInset, bottom: 0.0, right: 0.0)
        }
        
        return cell
    }
}

extension PhasesDataSource {
    private func viewModel(for indexPath: IndexPath) -> PhaseViewModel {
        return PhaseViewModel(phase: phases[indexPath.row])
    }
    
    @objc internal func phasesDidUpdate(with notification: Notification) -> Void {
        switch model.currentPhases {
        case .success(let phases):
            self.phases = phases
            tableView?.reloadData()
        case .failure(let error):
            print("error updating phases: \(error)")
        }
    }
}
