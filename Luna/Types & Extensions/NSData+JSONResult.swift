//
//  NSData+JSON.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias JSONResult = Result<JSON>

extension Data {
    func toJSONResult() -> JSONResult {
        do {
            let json = try self.toJSON()
            return JSONResult.success(json)
        } catch (let error) {
            return JSONResult.failure(JSONError.other(error))
        }
    }
}

func JSONResultFromData(_ data: Data) -> JSONResult {
    return data.toJSONResult()
}
