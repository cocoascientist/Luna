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
    init(failure error: ErrorProtocol)
    
    func map<U>(f: (Value) -> U) -> Result<U>
    func flatMap<U>(f: Value -> Result<U>) -> Result<U>
}

public enum Result<T>: ResultType {
    case Success(T)
    case Failure(ErrorProtocol)
    
    init(success value: T) {
        self = .Success(value)
    }
    
    init(failure error: ErrorProtocol) {
        self = .Failure(error)
    }
}

extension Result {
    func map<U>(f: T -> U) -> Result<U> {
        switch self {
        case let .Success(value):
            return Result<U>.Success(f(value))
        case let .Failure(error):
            return Result<U>.Failure(error)
        }
    }
    
    func flatMap<U>(f: T -> Result<U>) -> Result<U> {
        return Result.flatten(map(f))
    }
    
    static func flatten<T>(result: Result<Result<T>>) -> Result<T> {
        switch result {
        case let .Success(innerResult):
            return innerResult
        case let .Failure(error):
            return Result<T>.Failure(error)
        }
    }
}

extension Result: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .Success(let value):
            return "success: \(String(value))"
        case .Failure(let error):
            return "error: \(String(error))"
        }
    }
}
