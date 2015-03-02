//
//  NetworkController.swift
//  Luna
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias TaskResult = (result: Result<NSData>) -> Void

struct NetworkController {
    
    private class SessionDelegate: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {
        func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust))
        }
        
        func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest!) -> Void) {
            completionHandler(request)
        }
    }
    
    /**
    Creates an NSURLSessionTask for the request
    
    :param: request A reqeust object to return a task for
    :param: completion
    
    :returns: An NSURLSessionTask associated with the request
    */
    
    static func task(request: NSURLRequest, result: TaskResult) -> NSURLSessionTask {
        
        // handle the task completion job on the main thread
        let finished: TaskResult = {(taskResult) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                result(result: taskResult)
            })
        }
        
        let sessionDelegate = SessionDelegate()
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: NSOperationQueue.mainQueue())
        
        // return a basic NSURLSession for the request, with basic error handling
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
            if (err == nil && data != nil) {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        finished(result: success(data))
                    default:
                        let reason = Reason.NoSuccessStatusCode(statusCode: httpResponse.statusCode)
                        finished(result: Result.Failure(reason))
                    }
                } else {
                    finished(result: Result.Failure(Reason.BadResponse))
                }
            }
            else if data == nil {
                finished(result: Result.Failure(Reason.NoData))
            }
            else {
                finished(result: Result.Failure(Reason.Other(err)))
            }
        })
        
        return task;
    }
}
