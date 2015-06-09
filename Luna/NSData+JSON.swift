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
        let error : NSError?
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(self, options: [])
            
            if let jsonObject = json as? JSON {
                return .Success(Box(jsonObject))
            }
//            else if let err = error {
//                return .Failure(.Other(err))
//            }
//            else {
//                
//            }
        }
        catch {}
        
        return .Failure(.NoData)
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