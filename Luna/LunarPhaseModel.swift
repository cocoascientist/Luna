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
            case .Success(let box):
                self.updateLunarPhase(box.unbox)
            case .Failure(let reason):
                self.postErrorNotification(reason)
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidResume:", name: "UIApplicationDidBecomeActiveNotification", object: nil)
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
    
    func updateLunarPhase(location: Location) -> Void {
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
        
        self.loading = true
        
        self.networkController.task(moonRequest, result: moonResult).resume()
        self.networkController.task(phasesRequest, result: phasesResult).resume()
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_group_notify(group, queue) { () -> Void in
            self.loading = false
//            NSNotificationCenter.defaultCenter().postNotificationName(LunarModelDidUpdateNotification, object: nil)
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
    
    func applicationDidResume(notification: NSNotification) -> Void {
        if let location = self.locationTracker.currentLocation.result() {
            println("updating model on app resume...")
            self.updateLunarPhase(location)
        }
    }
}