//
//  NSData+JSON.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias JSONResult = Result<JSON>

extension NSData {
    func toJSONResult() -> JSONResult {
        do {
            let json = try self.toJSON()
            return JSONResult.Success(json)
        }
        catch (let error) {
            return JSONResult.Failure(JSONError.NoJSON(error))
        }
    }
}

func JSONResultFromData(data: NSData) -> JSONResult {
    return data.toJSONResult()
}