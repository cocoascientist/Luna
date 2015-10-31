//
//  NoDataURLProtocol.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

class BadResponseURLProtocol: NSURLProtocol {
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = self.client else { fatalError("Client is missing") }
        guard let url = request.URL else { fatalError("URL is missing") }
        
        let response = NSURLResponse(URL: url, MIMEType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        client.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
        client.URLProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // all data return at once, nothing to do
    }
}