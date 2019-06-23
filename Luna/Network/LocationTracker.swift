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
    
    private var lastLocation: Result<Location, Error> = .failure(LocationError.noData)
    private let locationManager: CLLocationManager
    
    private var willResignActiveSubscription: Cancellable?
    private var didBecomeActiveSubscription: Cancellable?
    
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
        
        willResignActiveSubscription = NotificationCenter.default
            .publisher(for: UIApplication.willResignActiveNotification)
            .map { _ in () }
            .sink(receiveValue: { [weak self] _ in
                self?.locationManager.stopUpdatingLocation()
            })
        
        didBecomeActiveSubscription = NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .map { _ in () }
            .sink(receiveValue: { [weak self] _ in
                self?.locationManager.startUpdatingLocation()
            })
    }
    
    deinit {
        willResignActiveSubscription?.cancel()
        didBecomeActiveSubscription?.cancel()
        
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Private

    private func shouldUpdate(with location: CLLocation) -> Bool {
        switch lastLocation {
        case .success(let loc):
            return location.distance(from: loc.physical) > 100
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
        lastLocation = .failure(NetworkError.other(error))
        _locationUpdateEvent.send(lastLocation)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            if shouldUpdate(with: currentLocation) {
                let location = Location(location: currentLocation, city: "", state: "", neighborhood: "")
                lastLocation = .success(location)
                _locationUpdateEvent.send(lastLocation)
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
