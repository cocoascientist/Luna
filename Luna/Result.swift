//
//  Result.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public enum Result<T, ErrorType> {
    case Success(T)
    case Failure(ErrorType)
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

extension Result {
    func result() -> T? {
        switch self {
        case .Success(let value):
            return value
        case .Failure:
            return nil
        }
    }
}

public func success<T, E>(value: T) -> Result<T, E> {
    return .Success(value)
}

public func failure<T, E>(error: E) -> Result<T, E> {
    return .Failure(error)
}