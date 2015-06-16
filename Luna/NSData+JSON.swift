//
//  NSData+JSON.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
typealias JSONResult = Result<JSON>

extension NSData {
    func toJSON() -> JSONResult {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(self, options: [])
            if let jsonObject = json as? JSON {
                return .Success(Box(jsonObject))
            }
            else {
                return .Failure(.NoData)
            }
        }
        catch {
            return .Failure(.BadJSON)
        }
    }
}

func toJSONResult(result: Result<NSData>) -> JSONResult {
    switch result {
    case .Success(let box):
        return box.unbox.toJSON()
    case .Failure(let reason):
        return .Failure(reason)
    }
}