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

typealias LocationResult = Result<Location>
typealias Observer = (_ location: LocationResult) -> ()

enum LocationError: Error {
    case noData
}

final class LocationTracker: NSObject {
    
    fileprivate var lastResult: LocationResult = .failure(LocationError.noData)
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
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocationTracker.handleBackgroundNotification(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocationTracker.handleForegroundNotification(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Public
    
    func addLocationChangeObserver(observer: @escaping Observer) -> Void {
        observers.append(observer)
    }
    
    // MARK: - Private
    
    @objc internal func handleBackgroundNotification(_ notification: NSNotification) {
        self.locationManager.stopUpdatingLocation()
    }
    
    @objc internal func handleForegroundNotification(_ notification: NSNotification) {
        self.locationManager.startUpdatingLocation()
    }
    
    fileprivate func publishChange(with result: LocationResult) {
        if self.shouldUpdate(with: result) {
            observers.forEach({ (observer) -> Void in
                observer(result)
            })
        }
    }
    
    fileprivate func shouldUpdate(with location: CLLocation) -> Bool {
        switch lastResult {
        case .success(let loc):
            return location.distance(from: loc.physical) > 100
        case .failure:
            return true
        }
    }
    
    fileprivate func shouldUpdate(with result: LocationResult) -> Bool {
        switch lastResult {
        case .success(let loc):
            let location = loc.physical
            return self.shouldUpdate(with: location)
        case .failure:
            return true
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationTracker: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let result = LocationResult.failure(NetworkError.other(error))
        self.publishChange(with: result)
        self.lastResult = result
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            if shouldUpdate(with: currentLocation) {
                let location = Location(location: currentLocation, city: "", state: "", neighborhood: "")
                
                let result = LocationResult.success(location)
                self.publishChange(with: result)
                self.lastResult = result
            }
            
            // location hasn't changed significantly
        }
    }
}

// MARK: - Location

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
