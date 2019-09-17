//
//  ContentProvider.swift
//  Luna
//
//  Created by Andrew Shepard on 9/13/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import Combine

enum ContentState {
    case loading
    case current(viewModel: ContentViewModel)
    case error(error: Error)
}

struct ContentViewModel {
    let lunarViewModel: LunarViewModel
    let phaseViewModel: [PhaseViewModel]
}

final class ContentProvider: ObservableObject {
    
    @Published var viewModel: ContentState = .loading
    
    private var cancelables: [AnyCancellable] = []
    
    init(locationTracker: LocationTracker = LocationTracker(),
         scheduler: DispatchQueue = DispatchQueue.main,
         session: URLSession) {
        
        let locationUpdateEvent = locationTracker.locationUpdateEvent
            .share()
            .eraseToAnyPublisher()
        
        let lunarChangeEvent = locationUpdateEvent
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
                guard let moon = moon else { return nil }
                return LunarViewModel(moon: moon)
            }
            .catch { _ in Just(nil) }
            .receive(on: scheduler)
            .eraseToAnyPublisher()
        
        let phasesChangeEvent = locationUpdateEvent
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
            .receive(on: scheduler)
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest(
            lunarChangeEvent,
            phasesChangeEvent
        )
        .compactMap { (lunarViewModel, phasesViewModel) -> ContentViewModel? in
            guard let lunarViewModel = lunarViewModel else { return nil }
            return ContentViewModel(
                lunarViewModel: lunarViewModel,
                phaseViewModel: phasesViewModel
            )
        }
        .map { (viewModel) -> ContentState in
            return .current(viewModel: viewModel)
        }
        .receive(on: scheduler)
        .assign(to: \.viewModel, on: self)
        .store(in: &cancelables)
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
    }
}
