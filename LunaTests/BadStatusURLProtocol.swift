//
//  BadStatusURLProtocol.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

class BadStatusURLProtocol: NSURLProtocol {
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 404, HTTPVersion: "HTTP/1.1", headerFields: nil)
        
        client?.URLProtocol(self, didReceiveResponse: response!, cacheStoragePolicy: .NotAllowed)
        client?.URLProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // all data return at once, nothing to do
    }
}