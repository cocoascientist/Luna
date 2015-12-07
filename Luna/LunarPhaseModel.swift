//
//  LunarPhaseModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

enum PhaseModelError: ErrorType {
    case NoMoon
    case NoPhases
}

typealias CurrentMoon = Result<Moon, PhaseModelError>
typealias CurrentPhases = Result<[Phase], PhaseModelError>

let MoonDidUpdateNotification = "MoonDidUpdateNotification"
let PhasesDidUpdateNotification = "PhasesDidUpdateNotification"

let LunarModelDidReceiveErrorNotification = "LunarModelDidReceiveErrorNotification"

class LunarPhaseModel: NSObject {
    let networkController: NetworkController
    
    dynamic var loading: Bool = false
    
    private var moon: Moon? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(MoonDidUpdateNotification, object: nil)
        }
    }
    
    private var phases: [Phase]? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(PhasesDidUpdateNotification, object: nil)
        }
    }
    
    private let locationTracker = LocationTracker()
    
    init(networkController: NetworkController = NetworkController()) {
        self.networkController = networkController
        super.init()
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .Success(let location):
                self.updateLunarPhase(location)
            case .Failure(let reason):
                self.postErrorNotification(reason)
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidResume:", name: "UIApplicationDidBecomeActiveNotification", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var currentMoon: CurrentMoon {
        if let moon = self.moon {
            return success(moon)
        }
        
        return failure(.NoMoon)
    }
    
    var currentPhases: CurrentPhases {
        if let phases = self.phases {
            return success(phases)
        }
        
        return failure(.NoPhases)
    }
    
    func updateLunarPhase(location: Location) -> Void {
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        dispatch_group_enter(group)
        
        let moonRequest = AerisAPI.Moon(location.physical).request
        let moonResult: TaskResult = {(result) -> Void in
            let jsonResult = toJSONResult(result)
            switch jsonResult {
            case .Success(let json):
                if let moonResult: MoonResult = Moon.moonFromJSON(json) {
                    switch moonResult {
                    case .Success(let moon):
                        self.moon = moon
                    case .Failure(let error):
                        self.postErrorNotification(error)
                    }
                }
                else {
                    self.postErrorNotification(NetworkError.BadResponse)
                }
            case .Failure(let error):
                self.postErrorNotification(error)
            }
            
            dispatch_group_leave(group)
        }
        
        let phasesRequest = AerisAPI.MoonPhases(location.physical).request
        let phasesResult: TaskResult = {(result) -> Void in
            let jsonResult = toJSONResult(result)
            switch jsonResult {
            case .Success(let json):
                let phasesResult = Phase.phasesFromJSON(json)
                switch phasesResult {
                case .Success(let phases):
                    self.phases = phases
                case .Failure(let error):
                    self.postErrorNotification(error)
                }
            case .Failure(let error):
                self.postErrorNotification(error)
            }
            
            dispatch_group_leave(group)
        }
        
        self.loading = true
        
        networkController.startRequest(moonRequest, result: moonResult)
        networkController.startRequest(phasesRequest, result: phasesResult)
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_group_notify(group, queue) { () -> Void in
            self.loading = false
        }
    }
    
    private func postErrorNotification(error: ErrorType) -> Void {
        NSNotificationCenter.defaultCenter().postNotificationName(LunarModelDidReceiveErrorNotification, object: nil, userInfo: nil)
    }
    
    func applicationDidResume(notification: NSNotification) -> Void {
        if let location = self.locationTracker.currentLocation.result() {
            self.updateLunarPhase(location)
        }
    }
}