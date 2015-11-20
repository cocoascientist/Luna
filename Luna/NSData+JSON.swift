//
//  NSData+JSON.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
typealias JSONResult = Result<JSON, NetworkError>

extension NSData {
    func toJSON() -> JSONResult {
        do {
            let obj = try NSJSONSerialization.JSONObjectWithData(self, options: [])
            guard let json = obj as? JSON else { return .Failure(.NoData) }
            return .Success(json)
        }
        catch {
            return .Failure(.BadJSON)
        }
    }
}

func toJSONResult(result: Result<NSData, NetworkError>) -> JSONResult {
    switch result {
    case .Success(let result):
        return result.toJSON()
    case .Failure(let error):
        return .Failure(error)
    }
}