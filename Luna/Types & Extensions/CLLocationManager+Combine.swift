//
//  CLLocationManager+Combine.swift
//  Luna
//
//  Created by Andrew Shepard on 8/23/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Combine
import CoreLocation

class LocationManagerSubscription<SubscriberType: Subscriber>: NSObject, CLLocationManagerDelegate, Subscription where SubscriberType.Input == Result<[CLLocation], Error> {
    
    private var subscriber: SubscriberType?
    private let locationManager: CLLocationManager
    
    init(subscriber: SubscriberType, locationManager: CLLocationManager) {
        self.subscriber = subscriber
        self.locationManager = locationManager
        super.init()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func request(_ demand: Subscribers.Demand) {
        // No need to handle `demand` because events are sent when they occur
    }
    
    func cancel() {
        subscriber = nil
    }
    
    // MARK: <CLLocationManagerDelegate>
    
    @objc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _ = subscriber?.receive(.failure(error))
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = subscriber?.receive(.success(locations))
    }
}

struct LocationPublisher: Publisher {
    typealias Output = Result<[CLLocation], Error>
    typealias Failure = Never
    
    private let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, LocationPublisher.Failure == S.Failure, LocationPublisher.Output == S.Input {
        let subscription = LocationManagerSubscription(subscriber: subscriber, locationManager: locationManager)
        subscriber.receive(subscription: subscription)
    }
}

extension CLLocationManager {
    func publisher() -> LocationPublisher {
        return LocationPublisher(locationManager: self)
    }
}
