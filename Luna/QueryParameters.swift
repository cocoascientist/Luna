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
    func queryParameters(string: String) -> [String] {
        let pairs = string.characters.split { $0 == "&" }.map { String($0) }
        let params = pairs.flatMap{ (string) -> String? in
            let value = string.characters.split { $0 == "=" }.map { String($0) } as [String]
            return value.first ?? nil
        }
        return params
    }
    
    static func queryString(parameters: QueryParameters) -> String {
        return queryWithParameters(parameters)
    }
}

func queryWithParameters(parameters: QueryParameters) -> String {
    return parameters.keys.reduce("") { (string, key) -> String in
        let prefix = (string == "") ? "" : "&"
        guard let value = parameters[key] else { fatalError("missing value") }
        return "\(string)\(prefix)\(key)=\(value)"
    }
}