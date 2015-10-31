//
//  FailingURLProtocol.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

class FailingURLProtocol: NSURLProtocol {
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = self.client else { fatalError("Client is missing") }
        guard let url = request.URL else { fatalError("URL is missing") }
        
        let error = NSError(domain: "org.andyshep.Luna", code: 404, userInfo: nil)
        guard let response = NSHTTPURLResponse(URL: url, statusCode: 404, HTTPVersion: "HTTP/1.1", headerFields: nil) else {
            fatalError("Response could not be created")
        }
        
        client.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
        client.URLProtocol(self, didFailWithError: error)
        client.URLProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // all data return at once, nothing to do
    }
}
