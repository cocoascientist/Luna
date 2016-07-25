//
//  NetworkController.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias TaskResult = (result: Result<Data>) -> Void

class NetworkController: Reachable {
    
    let configuration: URLSessionConfiguration
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.configuration = configuration
        
        let delegate = SessionDelegate()
        let queue = OperationQueue.main
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
    }
    
    deinit {
        session.finishTasksAndInvalidate()
    }
    
    private class SessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
        
        @objc(URLSession:didReceiveChallenge:completionHandler:) private func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
        
        @objc(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:) private func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest?) -> Void) {
            completionHandler(request)
        }
    }
    
    /**
    Creates and starts an NSURLSessionTask for the request.
    
    - parameter request: A request object
    - parameter completion: Called when the task finishes.
    
    - returns: An NSURLSessionTask associated with the request
    */
    
    func start(request: URLRequest, result: TaskResult) {
        
        // handle the task completion job on the main thread
        let finished: TaskResult = {(taskResult) in
            DispatchQueue.main.async(execute: { () -> Void in
                result(result: taskResult)
            })
        }
        
        // return a basic NSURLSession for the request, with basic error handling
        let task = session.dataTask(with: request, completionHandler: { (data, response, err) -> Void in
            guard let data = data else {
                guard let _ = err else {
                    return finished(result: .failure(NetworkError.noData))
                }
                
                return finished(result: .failure(NetworkError.other))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return finished(result: .failure(NetworkError.badResponse))
            }
            
            switch response.statusCode {
                case 200...204:
                    finished(result: .success(data))
                default:
                    let error = NetworkError.badStatusCode(statusCode: response.statusCode)
                    finished(result: .failure(error))
            }
        })
        
        switch self.reachable {
        case .online:
            task.resume()
        case .offline:
            finished(result: .failure(NetworkError.offline))
        }
    }
}
