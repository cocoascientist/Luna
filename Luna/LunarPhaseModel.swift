//
//  LunarPhaseModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

enum PhaseModelError: Error {
    case noMoon
    case noPhases
}

typealias CurrentMoon = Result<Moon>
typealias CurrentPhases = Result<[Phase]>

let MoonDidUpdateNotification: String = "MoonDidUpdateNotification"
let PhasesDidUpdateNotification: String = "PhasesDidUpdateNotification"
let LunarModelDidReceiveErrorNotification: String = "LunarModelDidReceiveErrorNotification"

class LunarPhaseModel: NSObject {
    let networkController: NetworkController
    
    dynamic var loading: Bool = false
    dynamic var error: NSError? = nil
    
    private var moon: Moon? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MoonDidUpdateNotification), object: nil)
        }
    }
    
    private var phases: [Phase]? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PhasesDidUpdateNotification), object: nil)
        }
    }
    
    private let locationTracker = LocationTracker()
    
    init(networkController: NetworkController = NetworkController()) {
        self.networkController = networkController
        super.init()
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let location):
                self.updateLunarPhase(using: location)
            case .failure(let error):
                self.postErrorNotification(error: error)
            }
        }
        
        let name = "UIApplicationDidBecomeActiveNotification" as NSNotification.Name
        NotificationCenter.default.addObserver(self, selector: #selector(LunarPhaseModel.applicationDidResume(notification:)), name: name, object: nil)
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
    
    func updateLunarPhase(using location: Location) -> Void {
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        
        let moonRequest = AerisAPI.moon(location.physical).request
        let moonResult: TaskResult = {(result) -> Void in
            
            let json = result.flatMap(JSONResultFromData)
            let moon = json.flatMap(Moon.moonFromJSON)
            
            switch moon {
            case .success(let moon):
                self.moon = moon
            case .failure(let error):
                self.postErrorNotification(error: error)
            }
            
            group.leave()
        }
        
        let phasesRequest = AerisAPI.moonPhases(location.physical).request
        let phasesResult: TaskResult = {(result) -> Void in
            
            let json = result.flatMap(JSONResultFromData)
            let phases = json.flatMap(Phase.phasesFromJSON)
            
            switch phases {
            case .success(let phases):
                self.phases = phases
            case .failure(let error):
                self.postErrorNotification(error: error)
            }
            
            group.leave()
        }
        
        self.loading = true
        
        networkController.start(request: moonRequest, result: moonResult)
        networkController.start(request: phasesRequest, result: phasesResult)
        
        let queue = DispatchQueue.global()
        
        group.notify(queue: queue) {
            self.loading = false
        }
    }
    
    private func postErrorNotification(error: Error) -> Void {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .other(let error):
                unpackAndHandle(error: error)
            default:
                unpackAndHandle(error: networkError)
            }
        } else {
            // post generic error
            let name = "LunarModelDidReceiveErrorNotification" as NSNotification.Name
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
    
    private func unpackAndHandle(error: NetworkError) -> Void {
        let name = "LunarModelDidReceiveErrorNotification" as NSNotification.Name
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    private func unpackAndHandle(error: NSError?) -> Void {
        var userInfo: [String: AnyObject] = [:]
        
        if let error = error {
            userInfo["OrignalErrorKey"] = error
            
            if error.domain == kCLErrorDomain {
                userInfo["Error"] = "Location Unknown"
            }
        }
        
        let name = "LunarModelDidReceiveErrorNotification" as NSNotification.Name
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    func applicationDidResume(notification: NSNotification) -> Void {
        switch locationTracker.currentLocation {
        case .success(let location):
            updateLunarPhase(using: location)
        case .failure:
            break
        }
    }
}
