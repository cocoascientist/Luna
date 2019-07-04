//
//  Publisher+Combine.swift
//  Luna
//
//  Created by Andrew Shepard on 6/18/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    static func empty() -> AnyPublisher<Output, Failure> {
        return Publishers.Empty()
            .eraseToAnyPublisher()
    }
    
    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }
    
    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Publishers.Fail(error: error)
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func flatMapLatest<T: Publisher>(_ transform: @escaping (Self.Output) -> T) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}
