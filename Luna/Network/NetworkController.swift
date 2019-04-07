//
//  NetworkController.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias TaskResult = (_ result: Result<Data, Error>) -> Void

final class NetworkController {
    
    private let configuration: URLSessionConfiguration
    private let session: URLSession
    
    /// Initializes a new instance of a `NetworkController`.
    ///
    /// - Parameter configuration: A `URLSessionConfiguration` to use when making requests.
    init(configuration: URLSessionConfiguration = .default) {
        self.configuration = configuration
        configuration.waitsForConnectivity = true
        
        let delegate = SessionDelegate()
        let queue = OperationQueue.main
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
    }
    
    deinit {
        session.finishTasksAndInvalidate()
    }
    
    private class SessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
        
        func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
            completionHandler(request)
        }
        
        func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
            print("waiting for connectivity...")
        }
    }
    
    /// Creates and starts an NSURLSessionTask for the request.
    ///
    /// - Parameters:
    ///   - request: A request object
    ///   - result: Called when the task finishes.
    func start(_ request: URLRequest, result: @escaping TaskResult) {
        
        let finished: TaskResult = {(taskResult) in
            DispatchQueue.main.async(execute: { () -> Void in
                result(taskResult)
            })
        }
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, err) -> Void in
            guard let data = data else {
                guard let _ = err else {
                    return finished(.failure(NetworkError.noData))
                }
                
                return finished(.failure(NetworkError.other(err)))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return finished(.failure(NetworkError.badResponse))
            }
            
            switch response.statusCode {
                case 200...204:
                    finished(.success(data))
                default:
                    let error = NetworkError.badStatusCode(statusCode: response.statusCode)
                    finished(.failure(error))
            }
        })
        
        task.resume()
    }
}
