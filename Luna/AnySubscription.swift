//
//  AnySubscription.swift
//  Luna
//
//  Created by Andrew Shepard on 6/18/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Combine

final class AnySubscription: Subscription {
    
    private let cancellable: AnyCancellable
    
    init(_ cancel: @escaping () -> Void) {
        self.cancellable = AnyCancellable(cancel)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        cancellable.cancel()
    }
}
