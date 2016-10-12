//
//  String+Query.swift
//  Luna
//
//  Created by Andrew Shepard on 11/10/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias QueryParameters = [String: String]

extension String {
    func queryParameters(from string: String) -> [String] {
        let pairs = string.characters.split { $0 == "&" }.map { String($0) }
        let params = pairs.flatMap{ (string) -> String? in
            let value = string.characters.split { $0 == "=" }.map { String($0) }
            return value.first ?? nil
        }
        return params
    }
    
    static func queryString(from parameters: QueryParameters) -> String {
        return query(with: parameters)
    }
}

func query(with parameters: QueryParameters) -> String {
    return parameters.keys.reduce("") { (string, key) -> String in
        let prefix = (string == "") ? "" : "&"
        guard let value = parameters[key] else { fatalError("missing value") }
        return "\(string)\(prefix)\(key)=\(value)"
    }
}
