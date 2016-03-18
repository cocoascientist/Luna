//
//  NetworkController.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias TaskResult = (result: Result<NSData>) -> Void

class NetworkController: Reachable {
    
    let configuration: NSURLSessionConfiguration
    private let session: NSURLSession
    
    init(configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()) {
        self.configuration = configuration
        
        let delegate = SessionDelegate()
        let queue = NSOperationQueue.mainQueue()
        self.session = NSURLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
    }
    
    deinit {
        session.finishTasksAndInvalidate()
    }
    
    private class SessionDelegate: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {
        
        @objc func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            completionHandler(.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
        }
        
        @objc func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
            completionHandler(request)
        }
    }
    
    /**
    Creates and starts an NSURLSessionTask for the request.
    
    - parameter request: A request object
    - parameter completion: Called when the task finishes.
    
    - returns: An NSURLSessionTask associated with the request
    */
    
    func startRequest(request: NSURLRequest, result: TaskResult) {
        
        // handle the task completion job on the main thread
        let finished: TaskResult = {(taskResult) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                result(result: taskResult)
            })
        }
        
        // return a basic NSURLSession for the request, with basic error handling
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
            guard let data = data else {
                guard let _ = err else {
                    return finished(result: .Failure(NetworkError.NoData))
                }
                
                return finished(result: .Failure(NetworkError.Other))
            }
            
            guard let response = response as? NSHTTPURLResponse else {
                return finished(result: .Failure(NetworkError.BadResponse))
            }
            
            switch response.statusCode {
                case 200...204:
                    finished(result: .Success(data))
                default:
                    let error = NetworkError.BadStatusCode(statusCode: response.statusCode)
                    finished(result: .Failure(error))
            }
        })
        
        switch self.reachable {
        case .Online:
            task.resume()
        case .Offline:
            finished(result: .Failure(NetworkError.Offline))
        }
    }
}
