//
//  TestURLProtocol.swift
//  Luna
//
//  Created by Andrew Shepard on 4/13/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

var requestCount = 0

class TestURLProtocol: NSURLProtocol {
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
        let client = self.client
        let request = self.request
        
        let data = self.dataForRequest(request)
        
        let headers = ["Content-Type": "application/json"]
        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: headers)
        
        client?.URLProtocol(self, didReceiveResponse: response!, cacheStoragePolicy: .NotAllowed)
        client?.URLProtocol(self, didLoadData: data)
        client?.URLProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // all data return at once, nothing to do
    }
    
    func dataForRequest(request: NSURLRequest) -> NSData {
        if let path = request.URL?.path {
            var json: String?
            if path.rangeOfString("/sunmoon/moonphases/") != nil {
                json = NSBundle(forClass: self.dynamicType).pathForResource("moonphases", ofType: "json")
            }
            else if path.rangeOfString("/sunmoon/") != nil {
                json = NSBundle(forClass: self.dynamicType).pathForResource("sunmoon", ofType: "json")
            }
            
            if json != nil {
                let data = NSData(contentsOfFile: json!)
                return data!
            }
        }

        return NSData()
    }
}
