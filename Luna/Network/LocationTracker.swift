//
//  LocationTracker.swift
//  Luna
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Combine
import CoreLocation
import UIKit
import SwiftUI

enum LocationError: Error {
    case noData
}

final class LocationTracker: NSObject {
    
    typealias LocationResult = Result<Location, Error>
    
    private var lastResult: LocationResult = .failure(LocationError.noData)
    private let locationManager: CLLocationManager
    
    var locationUpdateEvent: AnyPublisher<Result<Location, Error>, Never> {
        return _locationUpdateEvent.eraseToAnyPublisher()
    }
    private let _locationUpdateEvent = PassthroughSubject<Result<Location, Error>, Never>()
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocationTracker.handleBackgroundNotification(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocationTracker.handleForegroundNotification(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Private
    
    @objc internal func handleBackgroundNotification(_ notification: NSNotification) {
        locationManager.stopUpdatingLocation()
    }
    
    @objc internal func handleForegroundNotification(_ notification: NSNotification) {
        locationManager.startUpdatingLocation()
    }
    
    private func shouldUpdate(with location: CLLocation) -> Bool {
        switch lastResult {
        case .success(let loc):
            return location.distance(from: loc.physical) > 100
        case .failure:
            return true
        }
    }
    
    private func shouldUpdate(with result: LocationResult) -> Bool {
        switch lastResult {
        case .success(let location):
            return shouldUpdate(with: location.physical)
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
        lastResult = LocationResult.failure(NetworkError.other(error))
        _locationUpdateEvent.send(lastResult)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            if shouldUpdate(with: currentLocation) {
                let location = Location(location: currentLocation, city: "", state: "", neighborhood: "")
                lastResult = LocationResult.success(location)
                _locationUpdateEvent.send(lastResult)
            }
            
            // location hasn't changed significantly
        }
    }
}

// MARK: - Equatable

public struct Location: Equatable, Identifiable {
    public let id: UUID = UUID()
    
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
