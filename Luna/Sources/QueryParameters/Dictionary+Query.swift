//
//  Dictionary+Query.swift
//  Luna
//
//  Created by Andrew Shepard on 11/10/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String, Value == String {
    var queryString: String {
        return keys.reduce("") { (string, key) -> String in
            let prefix = (string == "") ? "" : "&"
            guard let value = self[key] else { fatalError("missing value") }
            return "\(string)\(prefix)\(key)=\(value)"
        }
    }
}
