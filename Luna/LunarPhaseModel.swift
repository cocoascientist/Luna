//
//  LunarPhaseModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

enum PhaseModelError: ErrorProtocol {
    case NoMoon
    case NoPhases
}

typealias CurrentMoon = Result<Moon>
typealias CurrentPhases = Result<[Phase]>

let MoonDidUpdateNotification = "MoonDidUpdateNotification"
let PhasesDidUpdateNotification = "PhasesDidUpdateNotification"

let LunarModelDidReceiveErrorNotification = "LunarModelDidReceiveErrorNotification"

class LunarPhaseModel: NSObject {
    let networkController: NetworkController
    
    dynamic var loading: Bool = false
    dynamic var error: NSError? = nil
    
    private var moon: Moon? {
        didSet {
            NSNotificationCenter.default().post(name: MoonDidUpdateNotification, object: nil)
        }
    }
    
    private var phases: [Phase]? {
        didSet {
            NSNotificationCenter.default().post(name: PhasesDidUpdateNotification, object: nil)
        }
    }
    
    private let locationTracker = LocationTracker()
    
    init(networkController: NetworkController = NetworkController()) {
        self.networkController = networkController
        super.init()
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .Success(let location):
                self.updateLunarPhase(location: location)
            case .Failure(let reason):
                self.postErrorNotification(error: reason)
            }
        }
        
        NSNotificationCenter.default().addObserver(self, selector: #selector(LunarPhaseModel.applicationDidResume(_:)), name: "UIApplicationDidBecomeActiveNotification", object: nil)
    }
    
    deinit {
        NSNotificationCenter.default().removeObserver(self)
    }
    
    var currentMoon: CurrentMoon {
        if let moon = self.moon {
            return .Success(moon)
        }
        
        return .Failure(PhaseModelError.NoMoon)
    }
    
    var currentPhases: CurrentPhases {
        if let phases = self.phases {
            return .Success(phases)
        }
        
        return .Failure(PhaseModelError.NoPhases)
    }
    
    func updateLunarPhase(location: Location) -> Void {
        guard let group = dispatch_group_create() else { fatalError() }
        
        dispatch_group_enter(group)
        dispatch_group_enter(group)
        
        let moonRequest = AerisAPI.Moon(location.physical).request
        let moonResult: TaskResult = {(result) -> Void in
            
            let json = result.flatMap(JSONResultFromData)
            let moon = json.flatMap(Moon.moonFromJSON)
            
            switch moon {
            case .Success(let moon):
                self.moon = moon
            case .Failure(let error):
                self.postErrorNotification(error: error)
            }
            
            dispatch_group_leave(group)
        }
        
        let phasesRequest = AerisAPI.MoonPhases(location.physical).request
        let phasesResult: TaskResult = {(result) -> Void in
            
            let json = result.flatMap(JSONResultFromData)
            let phases = json.flatMap(Phase.phasesFromJSON)
            
            switch phases {
            case .Success(let phases):
                self.phases = phases
            case .Failure(let error):
                self.postErrorNotification(error: error)
            }
            
            dispatch_group_leave(group)
        }
        
        self.loading = true
        
        networkController.start(request: moonRequest, result: moonResult)
        networkController.start(request: phasesRequest, result: phasesResult)
        
        guard let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) else { fatalError() }
        dispatch_group_notify(group, queue) { () -> Void in
            self.loading = false
        }
    }
    
    private func postErrorNotification(error: ErrorProtocol) -> Void {
        if let taskError = error as? NetworkError {
            let info = taskError.info
            NSNotificationCenter.default().post(name: LunarModelDidReceiveErrorNotification, object: nil, userInfo: info)
        }
        else {
            NSNotificationCenter.default().post(name: LunarModelDidReceiveErrorNotification, object: nil, userInfo: nil)
        }
    }
    
    func applicationDidResume(_ notification: NSNotification) -> Void {
        switch locationTracker.currentLocation {
        case .Success(let location):
            updateLunarPhase(location: location)
        case .Failure:
            break
        }
    }
}