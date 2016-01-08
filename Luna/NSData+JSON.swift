//
//  NSData+JSON.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public enum JSONError: ErrorType {
    case BadJSON
    case NoJSON
}

typealias JSON = [String: AnyObject]
typealias JSONResult = Result<JSON>

extension NSData {
    func toJSON() -> JSONResult {
        do {
            let obj = try NSJSONSerialization.JSONObjectWithData(self, options: [])
            guard let json = obj as? JSON else { return .Failure(JSONError.NoJSON) }
            return .Success(json)
        }
        catch {
            return .Failure(JSONError.BadJSON)
        }
    }
}

func JSONResultFromData(data: NSData) -> JSONResult {
    return data.toJSON()
}