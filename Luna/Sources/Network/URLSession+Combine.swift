//
//  URLSession+Combine.swift
//  Luna
//
//  Created by Andrew Shepard on 6/11/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import Combine
import Publishers

public extension URLSession {
    
    indirect enum Error: Swift.Error {
        case badStatusCode(_ statusCode: Int)
        case badResponse
        case badJSON
        case noData
        case offline
        case other(Swift.Error?)
    }
    
    func data(with request: URLRequest) -> AnyPublisher<Data, Swift.Error> {
        return dataTaskPublisher(for: request)
            .mapError { Error.other($0) }
            .flatMap { (data, response) -> AnyPublisher<Data, Swift.Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(Error.badResponse)
                }
                
                switch response.statusCode {
                case 200...204:
                    return .just(data)
                default:
                    let error = Error.badStatusCode(response.statusCode)
                    return .fail(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

extension URLSession.Error: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .badResponse:
            return NSLocalizedString("Bad response object returned", comment: "")
        case .badJSON:
            return NSLocalizedString("Bad JSON object, unable to parse", comment: "")
        case .noData:
            return NSLocalizedString("No response data", comment: "")
        case .offline:
            return NSLocalizedString("No internet connection is available", comment: "")
        case .badStatusCode(let statusCode):
            return "Bad status code returned: \(statusCode)"
        case .other(let error):
            return "NetworkError: \(String(describing: error))"
        }
    }
}
