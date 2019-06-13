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
    func data(with request: URLRequest) -> Publishers.Future<Data, Error> {
        return Publishers.Future<Data, Error> { subscriber in
            let task = self.dataTask(with: request, completionHandler: { (data, response, err) -> Void in
                guard let data = data else {
                    guard let _ = err else {
                        return subscriber(.failure(NetworkError.noData))
                    }
                    
                    return subscriber(.failure(NetworkError.other(err)))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    return subscriber(.failure(NetworkError.badResponse))
                }
                
                switch response.statusCode {
                case 200...204:
                    subscriber(.success(data))
                default:
                    let error = NetworkError.badStatusCode(statusCode: response.statusCode)
                    subscriber(.failure(error))
                }
            })
            
            task.resume()
        }
    }
}
