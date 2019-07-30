//
//  ContentViewModel.swift
//  Luna
//
//  Created by Andrew Shepard on 6/12/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Combine
import SwiftUI

class ContentViewModel {
    
    var lunarViewModel: LunarViewModel? = nil {
        didSet { _lunarViewModelDidChange.send(()) }
    }
    var phaseViewModels: [PhaseViewModel] = [] {
        didSet { _phaseViewModelDidChange.send(()) }
    }
    
    private var locationChangeSubscriber: AnySubscriber<Result<Location, Error>, Never>?
    private var lunarChangeSubscriber: AnyCancellable?
    private var phaseChangeSubscriber: AnyCancellable?
    
    private let locationTracker = LocationTracker()
    
    private let _contentViewModelWillChange = PassthroughSubject<Void, Never>()
    
    private let _lunarViewModelDidChange = PassthroughSubject<Void, Never>()
    private let _phaseViewModelDidChange = PassthroughSubject<Void, Never>()
    
    init(scheduler: DispatchQueueScheduler = DispatchQueueScheduler.main,
         session: URLSession = URLSession.shared) {
        
        lunarChangeSubscriber = locationTracker.locationUpdateEvent
            .compactMap { (result) -> URLRequest? in
                guard case .success(let location) = result else { return nil }
                return AerisAPI.moon(location.physical).request
            }
            .flatMap { request in
                return session.data(with: request)
                    .catch { _ in Just(Data()) }
            }
            .decode(type: Moon?.self, decoder: JSONDecoder())
            .compactMap{ (moon) -> LunarViewModel? in
                guard let moon = moon else {
                    return nil
                }
                return LunarViewModel(moon: moon)
            }
            .catch { _ in Just(nil) }
            .receive(on: scheduler)
            .assign(to: \.lunarViewModel, on: self)
        
        phaseChangeSubscriber = locationTracker.locationUpdateEvent
            .compactMap { (result) -> URLRequest? in
                guard case .success(let location) = result else { return nil }
                return AerisAPI.moonPhases(location.physical).request
            }
            .flatMap { (request) in
                return session.data(with: request)
                    .catch { _ in Just(Data()) }
            }
            .tryMap { (data) -> [Phase] in
                return try decodePhases(from: data)
            }
            .catch { _ in Just([]) }
            .compactMap{ (phases) -> [PhaseViewModel] in
                return phases.map { PhaseViewModel(phase: $0) }
            }
            .catch { _ in Just([]) }
            .receive(on: scheduler)
            .assign(to: \.phaseViewModels, on: self)
    }
    
    deinit {
        lunarChangeSubscriber?.cancel()
        phaseChangeSubscriber?.cancel()
    }
}

extension ContentViewModel: ObservableObject {
    typealias PublisherType = AnyPublisher<Void, Never>
    
    var willChange: AnyPublisher<Void, Never> {
        return Publishers.CombineLatest(
            _lunarViewModelDidChange.eraseToAnyPublisher(),
            _phaseViewModelDidChange.eraseToAnyPublisher()
        )
        .flatMapLatest { _ in
            return Just(())
        }
        .eraseToAnyPublisher()
    }
}
