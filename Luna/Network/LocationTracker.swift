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

final class LocationTracker {
    
    private var lastLocation: Result<Location, Error> = .failure(LocationError.noData)
    private let locationManager: CLLocationManager
    private let geocoder: CLGeocoder = CLGeocoder()
    
    private var willResignActiveSubscription: Cancellable?
    private var didBecomeActiveSubscription: Cancellable?
    
    var locationUpdateEvent: AnyPublisher<Result<Location, Error>, Never> {
        return locationManager
            .publisher()
            .compactMap { (result) -> CLLocation? in
                switch result {
                case .success(let locations):
                    return locations.first
                case .failure:
                    return nil
                }
            }
            .flatMap { (location) -> AnyPublisher<Result<Location, Error>, Never> in
                return self.geocoder
                    .reverseGeocodingPublisher(for: location)
                    .map { (result) in
                        switch result {
                        case .success(let placemarks):
                            return placemarks.location(physical: location)
                        case .failure(let error):
                            return .failure(error)
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    private let _locationUpdateEvent = PassthroughSubject<Result<Location, Error>, Never>()
    
    private var cancelables: [AnyCancellable] = []
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        
        NotificationCenter.default
            .publisher(for: UIApplication.willResignActiveNotification)
            .map { _ in () }
            .sink(receiveValue: { [weak self] _ in
                self?.locationManager.stopUpdatingLocation()
            })
            .store(in: &cancelables)
        
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .map { _ in () }
            .sink(receiveValue: { [weak self] _ in
                self?.locationManager.startUpdatingLocation()
            })
            .store(in: &cancelables)
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
        locationManager.stopUpdatingLocation()
    }
}

struct Location: Equatable, Identifiable {
    let id: UUID = UUID()
    
    let physical: CLLocation
    let city: String
    let state: String
    
    init(location physical: CLLocation, city: String, state: String) {
        self.physical = physical
        self.city = city
        self.state = state
    }
}

func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.physical == rhs.physical
}

private extension Array where Element: CLPlacemark {
    func location(physical: CLLocation) -> Result<Location, Error> {
        guard
            let placemark = self.first,
            let city = placemark.locality,
            let state = placemark.administrativeArea
        else { return .failure(LocationError.noData) }
        
        let location = Location(location: physical, city: city, state: state)
        return .success(location)
    }
}
