//
//  JSON.swift
//  Luna
//
//  Created by Andrew Shepard on 2/18/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation

public typealias JSON = [String: AnyObject]

public protocol JSONRepresentable {
    func toJSON() throws -> JSON
}

public protocol JSONConstructable {
    init?(json: JSON)
}

public enum JSONError: Error {
    case badFormat
    case other(Error)
}

extension Data: JSONRepresentable {
    public func toJSON() throws -> JSON {
        do {
            let obj = try JSONSerialization.jsonObject(with: self, options: [])
            guard let json = obj as? JSON else { throw JSONError.badFormat }
            return json
        } catch (let error) {
            throw JSONError.other(error)
        }
    }
}
