//
//  MockLocationTracker.swift
//  Luna
//
//  Created by Andrew Shepard on 6/30/20.
//

import Foundation
import Combine
import CoreLocation

struct MockLocationTracker: LocationTracking {
    var locationUpdateEvent: AnyPublisher<Result<Location, Error>, Never> {
        return locationUpdateSubject.share().eraseToAnyPublisher()
    }
    
    private let locationUpdateSubject =
        CurrentValueSubject<Result<Location, Error>, Never>(.success(Location.mockLocation))
}

extension Location {
    static var mockLocation: Location {
        let position = CLLocation(latitude: 25.7617, longitude: 80.1918)
        let location = Location(location: position, city: "Miami", state: "FL")
        return location
    }
}

enum MockError: Error {
    case mock
}
