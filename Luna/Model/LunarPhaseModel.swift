//
//  LunarPhaseModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

enum PhaseModelError: LocalizedError {
    case noMoon
    case noPhases
    
    var localizedDescription: String {
        switch self {
        case .noMoon: return NSLocalizedString("Error finding current moon phase", comment: "")
        case .noPhases: return NSLocalizedString("Error finding upcoming moon phases", comment: "")
        }
    }
}

typealias CurrentMoon = Result<Moon, Error>
typealias CurrentPhases = Result<[Phase], Error>

typealias UpdateCompletion = () -> ()

extension Notification.Name {
    static let didUpdateMoon = Notification.Name("didUpdateMoon")
    static let didUpdatePhases = Notification.Name("didUpdatePhases")
    static let didReceiveLunarModelError = Notification.Name("didReceiveLunarModelError")
}

final class LunarPhaseModel: NSObject {
    @objc dynamic var loading: Bool = false
    
    private var moon: Moon? {
        didSet {
            NotificationCenter.default.post(name: .didUpdateMoon, object: nil)
        }
    }
    
    private var phases: [Phase]? {
        didSet {
            NotificationCenter.default.post(name: .didUpdatePhases, object: nil)
        }
    }
    
    private let networkController: NetworkController
    private let locationTracker = LocationTracker()
    
    init(networkController: NetworkController = NetworkController()) {
        self.networkController = networkController
        super.init()
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let location):
                self.updateLunarPhase(using: location)
            case .failure(let error):
                self.postErrorNotification(error)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var currentMoon: CurrentMoon {
        if let moon = self.moon {
            return .success(moon)
        }
        
        return .failure(PhaseModelError.noMoon)
    }
    
    var currentPhases: CurrentPhases {
        if let phases = self.phases {
            return .success(phases)
        }
        
        return .failure(PhaseModelError.noPhases)
    }
    
    func refresh(completion: UpdateCompletion? = nil) {
        let result = locationTracker.currentLocation
        switch result {
        case .success(let location):
            updateLunarPhase(using: location, completion: completion)
        case .failure(let error):
            // TODO: error
            print("no location, could not refresh: \(error)")
            completion?()
        }
    }
    
    internal func updateLunarPhase(using location: Location, completion: UpdateCompletion? = nil) -> Void {
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        
        let moonRequest = AerisAPI.moon(location.physical).request
        let moonResult: TaskResult = {(result) -> Void in
            let moonResult = result.flatMap(MoonResultFromData)
            switch moonResult {
            case .success(let moon):
                self.moon = moon
            case .failure(let error):
                self.postErrorNotification(error)
            }
            
            group.leave()
        }
        
        let phasesRequest = AerisAPI.moonPhases(location.physical).request
        let phasesResult: TaskResult = {(result) -> Void in
            
            switch result {
            case .success(let value):
                let phaseResult = PhasesResultFromData(value)
                
                switch phaseResult {
                case .success(let phases):
                    self.phases = phases
                case .failure(let error):
                    self.postErrorNotification(error)
                }
            case .failure(let error):
                self.postErrorNotification(error)
            }
            
//            let phases = result.flatMap(PhasesResultFromData)
//
//            switch phases {
//            case .success(let phases):
//                self.phases = phases
//            case .failure(let error):
//                self.postErrorNotification(error)
//            }
            
            group.leave()
        }
        
        self.loading = true
        
        networkController.start(moonRequest, result: moonResult)
        networkController.start(phasesRequest, result: phasesResult)
        
        let queue = DispatchQueue.global()
        
        group.notify(queue: queue) {
            self.loading = false
            completion?()
        }
    }
    
    private func postErrorNotification(_ error: Error) -> Void {
        NotificationCenter.default.post(name: .didReceiveLunarModelError, object: error)
    }
}
