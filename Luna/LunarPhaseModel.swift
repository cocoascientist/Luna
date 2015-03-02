//
//  LunarPhaseModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias CurrentMoon = Result<Moon>
typealias CurrentPhases = Result<[Phase]>

let LunarModelDidUpdateNotification = "LunarModelDidUpdateNotification"
let PhasesDidUpdateNotification = "PhasesDidUpdateNotification"

let LunarModelDidReceiveErrorNotification = "LunarModelDidReceiveErrorNotification"

class LunarPhaseModel {
    private var moon: Moon? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(LunarModelDidUpdateNotification, object: nil)
        }
    }
    
    private var phases: [Phase]? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(PhasesDidUpdateNotification, object: nil)
        }
    }
    
    private let locationTracker = LocationTracker()
    
    init() {
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .Success(let box):
                self.updateLunarPhase(box.unbox)
            case .Failure(let reason):
                self.postErrorNotification(reason)
            }
        }
    }
    
    var currentMoon: CurrentMoon {
        if let moon = self.moon {
            return success(moon)
        }
        
        return failure(.NoData)
    }
    
    var currentPhases: CurrentPhases {
        if let phases = self.phases {
            return success(phases)
        }
        
        return failure(.NoData)
    }
    
    // MARK: - Private
    
    private func updateLunarPhase(location: Location) -> Void {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        dispatch_group_enter(group)
        
        let moonRequest = AerisAPI.Moon(location.physical).request()
        let moonResult: TaskResult = {(result) -> Void in
            let jsonResult = toJSONResult(result)
            switch jsonResult {
            case .Success(let json):
                if let moon = Moon.moonFromJSON(json.unbox) {
                    self.moon = moon
                }
                else {
                    self.postErrorNotification(.BadResponse)
                }
            case .Failure(let reason):
                self.postErrorNotification(reason)
            }
            
            dispatch_group_leave(group)
        }
        
        let phasesRequest = AerisAPI.MoonPhases(location.physical).request()
        let phasesResult: TaskResult = {(result) -> Void in
            let jsonResult = toJSONResult(result)
            switch jsonResult {
            case .Success(let json):
                if let phases = Phase.phasesFromJSON(json.unbox) {
                    self.phases = phases
                }
                else {
                    self.postErrorNotification(.BadResponse)
                }
            case .Failure(let reason):
                self.postErrorNotification(reason)
            }
            
            dispatch_group_leave(group)
        }
        
        NetworkController.task(moonRequest, result: moonResult).resume()
        NetworkController.task(phasesRequest, result: phasesResult).resume()
        
        dispatch_group_notify(group, queue) { () -> Void in
            println("all done")
            NSNotificationCenter.defaultCenter().postNotificationName(LunarModelDidUpdateNotification, object: nil)
        }
    }
    
    private func postErrorNotification(reason: Reason) -> Void {
        switch reason {
        case .Other(let error):
            NSNotificationCenter.defaultCenter().postNotificationName(LunarModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": error])
        default:
            NSNotificationCenter.defaultCenter().postNotificationName(LunarModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": reason.description])
        }
        
    }
}