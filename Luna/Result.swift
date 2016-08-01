//
//  Result.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

protocol ResultType {
    associatedtype Value
    
    init(success value: Value)
    init(failure error: Error)
    
    func map<U>(_ f: (Value) -> U) -> Result<U>
    func flatMap<U>(_ f: (Value) -> Result<U>) -> Result<U>
}

public enum Result<T>: ResultType {
    case success(T)
    case failure(Error)
    
    init(success value: T) {
        self = .success(value)
    }
    
    init(failure error: Error) {
        self = .failure(error)
    }
}

extension Result {
    func map<U>(_ f: (T) -> U) -> Result<U> {
        switch self {
        case let .success(value):
            return Result<U>.success(f(value))
        case let .failure(error):
            return Result<U>.failure(error)
        }
    }
    
    func flatMap<U>(_ f: (T) -> Result<U>) -> Result<U> {
        return Result.flatten(map(f))
    }
    
    static func flatten<T>(_ result: Result<Result<T>>) -> Result<T> {
        switch result {
        case let .success(innerResult):
            return innerResult
        case let .failure(error):
            return Result<T>.failure(error)
        }
    }
}

extension Result: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "success: \(String(value))"
        case .failure(let error):
            return "error: \(String(error))"
        }
    }
}
