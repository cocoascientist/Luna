//
//  ContentViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 6/12/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum LunaError: Error {
    case malformedMoonResponse
}

class ContentViewModel {
    
    var lunarViewModel: LunarViewModel? = nil
    var phaseViewModels: [PhaseViewModel] = []
    
    private let lunarViewModelPublisher: AnyPublisher<LunarViewModel?, Never>
    private let phaseViewModelsPublisher: AnyPublisher<[PhaseViewModel], Never>
    
    private let locationTracker = LocationTracker()
    
    init(scheduler: DispatchQueueScheduler, session: URLSession = URLSession.shared) {
        
        let locationUpdateEvent = locationTracker.locationUpdateEvent
            .share()
        
        lunarViewModelPublisher = locationUpdateEvent
            .compactMap { (result) -> URLRequest? in
                guard case .success(let location) = result else { return nil }
                return AerisAPI.moon(location.physical).request
            }
            .flatMap { (request) in
                return session.data(with: request)
                    .catch { error in
                        return Publishers.Just(Data())
                    }
            }
            .decode(type: Moon?.self, decoder: JSONDecoder())
            .compactMap{ (moon) -> LunarViewModel? in
                guard let moon = moon else {
                    return nil
                }
                return LunarViewModel(moon: moon)
            }
            .catch { _ in Publishers.Just(nil) }
            .receive(on: scheduler)
            .eraseToAnyPublisher()
        
        phaseViewModelsPublisher = locationUpdateEvent
            .compactMap { (result) -> URLRequest? in
                guard case .success(let location) = result else { return nil }
                return AerisAPI.moonPhases(location.physical).request
            }
            .flatMap { (request) in
                return session.data(with: request)
                    .catch { _ in Publishers.Just(Data()) }
            }
            .tryMap { (data) -> [Phase] in
                return try decodePhases(from: data)
            }
            .catch { error in
                Publishers.Just([])
            }
            .compactMap{ (phases) -> [PhaseViewModel] in
                return phases.map { PhaseViewModel(phase: $0) }
            }
            .catch { _ in
                Publishers.Just([])
            }
            .receive(on: scheduler)
            .eraseToAnyPublisher()
        
        _ = phaseViewModelsPublisher
            .assign(to: \.phaseViewModels, on: self)
        
        _ = lunarViewModelPublisher
            .assign(to: \.lunarViewModel, on: self)
    }
}

extension ContentViewModel: BindableObject {
    var didChange: AnyPublisher<Void, Never> {
        return Publishers
            .Merge(
                lunarViewModelPublisher
                    .flatMap { _ in Publishers.Just(()) },
                phaseViewModelsPublisher
                    .flatMap { _ in Publishers.Just(()) }
            )
            .flatMap { _ in Publishers.Just(()) }
            .eraseToAnyPublisher()
    }
}
