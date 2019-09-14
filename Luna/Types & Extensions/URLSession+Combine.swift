//
//  URLSession+Combine.swift
//  Luna
//
//  Created by Andrew Shepard on 6/11/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import Combine

extension URLSession {
    internal enum URLSessionError: Error {
        case badStatusCode(statusCode: Int)
        case badResponse
        case badJSON
        case noData
        case offline
        case other(Error?)
    }
    
    func data(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return dataTaskPublisher(for: request)
            .mapError { URLSessionError.other($0) }
            .flatMap { (data, response) -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(URLSessionError.badResponse)
                }
                
                switch response.statusCode {
                case 200...204:
                    return .just(data)
                default:
                    let error = URLSessionError.badStatusCode(statusCode: response.statusCode)
                    return .fail(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

extension URLSession.URLSessionError: LocalizedError {
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
