//
//  LocationTracker.swift
//  Luna
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

public typealias LocationResult = Result<Location>
public typealias Observer = (location: LocationResult) -> ()

enum LocationError: ErrorProtocol {
    case NoData
}

public class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    private var lastResult: LocationResult = .Failure(LocationError.NoData)
    private var observers: [Observer] = []
    
    private let locationManager: CLLocationManager
    
    var currentLocation: LocationResult {
        return self.lastResult
    }
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LocationTracker.handleBackgroundNotification(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LocationTracker.handleForegroundNotification(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Public
    
    func addLocationChangeObserver(observer: Observer) -> Void {
        observers.append(observer)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    @objc(locationManager:didChangeAuthorizationStatus:)
    public func locationManager(manager: CLLocationManager, didChange status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let result = LocationResult.Failure(NetworkError.Other)
        self.publishChangeWithResult(result)
        self.lastResult = result
    }
    
    @objc(locationManager:didUpdateLocations:)
    public func locationManager(manager: CLLocationManager, didUpdate locations: [CLLocation]) {
        if let currentLocation = locations.first {
            if shouldUpdateWithLocation(currentLocation) {
                let location = Location(location: currentLocation, city: "", state: "", neighborhood: "")
                
                let result = LocationResult.Success(location)
                self.publishChangeWithResult(result)
                self.lastResult = result
            }
            
            // location hasn't changed significantly
        }
    }
    
    // MARK: - Private
    
    func handleBackgroundNotification(notification: NSNotification) {
        self.locationManager.stopUpdatingLocation()
    }
    
    func handleForegroundNotification(notification: NSNotification) {
        self.locationManager.startUpdatingLocation()
    }
    
    private func publishChangeWithResult(result: LocationResult) {
        if self.shouldUpdateWithResult(result) {
            let _ = observers.map { (observer) -> Void in
                observer(location: result)
            }
        }
    }
    
    private func shouldUpdateWithLocation(location: CLLocation) -> Bool {
        switch lastResult {
        case .Success(let loc):
            return location.distance(from: loc.physical) > 100
        case .Failure:
            return true
        }
    }
    
    private func shouldUpdateWithResult(result: LocationResult) -> Bool {
        switch lastResult {
        case .Success(let loc):
            let location = loc.physical
            return self.shouldUpdateWithLocation(location)
        case .Failure:
            return true
        }
    }
}

public struct Location: Equatable {
    let physical: CLLocation
    let city: String
    let state: String
    let neighborhood: String
    
    init(location physical: CLLocation, city: String, state: String, neighborhood: String) {
        self.physical = physical
        self.city = city
        self.state = state
        self.neighborhood = neighborhood
    }
}

public func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.physical == rhs.physical
}
