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
    
    private let locationSubject: CurrentValueSubject<Result<CLLocation, Error>, Never>
    
    var locationUpdateEvent: AnyPublisher<Result<Location, Error>, Never> {
        return locationSubject
            .flatMap { (result) -> AnyPublisher<Result<Location, Error>, Never> in
                switch result {
                case .success(let location):
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
                case .failure(let error):
                    return Just(Result<Location, Error>.failure(error))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    private let _locationUpdateEvent = PassthroughSubject<Result<Location, Error>, Never>()
    
    private var cancelables: [AnyCancellable] = []
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        self.locationSubject = CurrentValueSubject(.failure(LocationError.noData))
        
        watchForApplicationLifecycleChanges()
        watchForLocationChanges()
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
        locationManager.stopUpdatingLocation()
    }
    
    private func watchForApplicationLifecycleChanges() {
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
    
    private func watchForLocationChanges() {
        let locationPublisher = locationManager
            .publisher()
            .share()
        
        // grab the first location and respond to it
        locationPublisher
            .prefix(1)
            .sink { [weak self] (result) in
                self?.updateLocationSubject(with: result)
            }
            .store(in: &cancelables)
        
        // then grab a new location every 60 seconds
        locationPublisher
            .dropFirst()
            .throttle(for: 60.0, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] (result) in
                self?.updateLocationSubject(with: result)
            }
            .store(in: &cancelables)
    }
    
    private func updateLocationSubject(with result: Result<[CLLocation], Error>) {
        switch result {
        case .success(let locations):
            if let location = locations.first {
                locationSubject.send(.success(location))
            } else {
                locationSubject.send(.failure(LocationError.noData))
            }
        case .failure(let error):
            locationSubject.send(.failure(error))
        }
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
