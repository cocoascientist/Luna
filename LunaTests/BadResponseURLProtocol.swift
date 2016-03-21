//
//  NoDataURLProtocol.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

class BadResponseURLProtocol: NSURLProtocol {
    
    override class func canInit(with request: NSURLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = self.client else { fatalError("Client is missing") }
        guard let url = request.url else { fatalError("URL is missing") }
        
        let response = NSURLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // all data return at once, nothing to do
    }
}