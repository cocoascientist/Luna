//
//  LocalURLProtocol.swift
//  Luna
//
//  Created by Andrew Shepard on 4/13/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

class LocalURLProtocol: NSURLProtocol {
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = self.client else { fatalError("Client is missing") }
        guard let url = request.URL else { fatalError("URL is missing") }
        
        let data = self.dataForRequest(request)
        let headers = ["Content-Type": "application/json"]
        guard let response = NSHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: headers) else {
            fatalError("Response could not be created")
        }
        
        client.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
        client.URLProtocol(self, didLoadData: data)
        client.URLProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // all data return at once, nothing to do
    }
    
    private func dataForRequest(request: NSURLRequest) -> NSData {
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
