//
//  ContentProvider.swift
//  Luna
//
//  Created by Andrew Shepard on 9/13/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import ViewModel
import Model
import Network
import Waypoints

public final class ContentProvider: ObservableObject {
    
    public enum State {
        case loading
        case current(lunarViewModel: LunarViewModel, phaseViewModels: [PhaseViewModel])
        case error(_ error: Swift.Error)
    }
    
    public enum Error: Swift.Error {
        case noData
    }
    
    @Published public var state: ContentProvider.State = .loading
    
    private var cancelables: [AnyCancellable] = []
    
    public init(locationTracker: LocationTracking = LocationTracker(),
         scheduler: DispatchQueue = DispatchQueue.main,
         session: URLSession) {
        
        let locationUpdateEvent = locationTracker.locationUpdatePublisher
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
                return try Phase.decodePhases(from: data)
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
        .map { (lunarViewModel, phaseViewModels) -> State in
            guard let lunarViewModel = lunarViewModel else {
                return .error(Error.noData)
            }
            return .current(
                lunarViewModel: lunarViewModel,
                phaseViewModels: phaseViewModels
            )
        }
        .receive(on: scheduler)
        .assign(to: \.state, on: self)
        .store(in: &cancelables)
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
    }
}
