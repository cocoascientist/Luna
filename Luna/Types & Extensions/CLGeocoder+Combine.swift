//
//  CLGeocoder+Combine.swift
//  Luna
//
//  Created by Andrew Shepard on 8/23/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Combine
import CoreLocation

enum GeocoderError: Error {
    case notFound
    case other(Error)
}

class ReverseGeocoderSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == Result<[CLPlacemark], GeocoderError> {
    
    private var subscriber: SubscriberType?
    private let geocoder: CLGeocoder
    
    init(subscriber: SubscriberType, location: CLLocation, geocoder: CLGeocoder) {
        self.subscriber = subscriber
        self.geocoder = geocoder
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                _ = subscriber.receive(.failure(.other(error)))
            } else if let placemarks = placemarks {
                _ = subscriber.receive(.success(placemarks))
            } else {
                _ = subscriber.receive(.failure(.notFound))
            }
        }
    }
    
    func request(_ demand: Subscribers.Demand) {
        // No need to handle `demand` because events are sent when they occur
    }
    
    func cancel() {
        subscriber = nil
    }
}

struct ReverseGeocoderPublisher: Publisher {
    typealias Output = Result<[CLPlacemark], GeocoderError>
    typealias Failure = Never
    
    private let location: CLLocation
    private let geocoder: CLGeocoder
    
    init(location: CLLocation, geocoder: CLGeocoder = CLGeocoder()) {
        self.location = location
        self.geocoder = geocoder
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, ReverseGeocoderPublisher.Failure == S.Failure, ReverseGeocoderPublisher.Output == S.Input {
        let subscription = ReverseGeocoderSubscription(
            subscriber: subscriber,
            location: location,
            geocoder: geocoder
        )
        subscriber.receive(subscription: subscription)
    }
}

extension CLGeocoder {
    func reverseGeocodingPublisher(for location: CLLocation) -> ReverseGeocoderPublisher {
        return ReverseGeocoderPublisher(location: location, geocoder: self)
    }
}
