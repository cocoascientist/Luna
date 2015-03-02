//
//  LunarPhaseModel.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias CurrentMoon = Result<Moon>

let LunarModelDidUpdateNotification = "LunarModelDidUpdateNotification"
let LunarModelDidReceiveErrorNotification = "LunarModelDidReceiveErrorNotification"

class LunarPhaseModel {
    private var moon: Moon? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(LunarModelDidUpdateNotification, object: nil)
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
    
    // MARK: - Private
    
    private func updateLunarPhase(location: Location) -> Void {
        let request = AerisAPI.SunMoon(location.physical).request()
        let result: TaskResult = {(result) -> Void in
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
        }
        
        NetworkController.task(request, result: result).resume()
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