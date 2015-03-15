//
//  Result.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public class Box<T> {
    let unbox: T
    
    init(_ value: T) {
        self.unbox = value
    }
}

public enum Result<T> {
    case Success(Box<T>)
    case Failure(Reason)
}

extension Result: Printable {
    public var description: String {
        switch self {
        case .Success(let box):
            return "value: \(box.unbox)"
        case .Failure(let string):
            return "failure: \(string)"
        }
    }
}

extension Result {
    func result() -> T? {
        switch self {
        case .Success(let box):
            return box.unbox
        case .Failure:
            return nil
        }
    }
}

public func success<T>(value: T) -> Result<T> {
    return .Success(Box(value))
}

public func failure<T>(reason: Reason) -> Result<T> {
    return .Failure(reason)
}