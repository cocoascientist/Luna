//
//  Result.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Failure(Reason)
}

extension Result: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Success(let value):
            return "value: \(value)"
        case .Failure(let string):
            return "failure: \(string)"
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

public func success<T>(value: T) -> Result<T> {
    return .Success(value)
}

public func failure<T>(reason: Reason) -> Result<T> {
    return .Failure(reason)
}