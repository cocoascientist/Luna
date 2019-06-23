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
    func data(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return dataTaskPublisher(for: request)
            .mapError { NetworkError.other($0) }
            .flatMap { (data, response) -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(NetworkError.badResponse)
                }
                
                switch response.statusCode {
                case 200...204:
                    return .just(data)
                default:
                    let error = NetworkError.badStatusCode(statusCode: response.statusCode)
                    return .fail(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
