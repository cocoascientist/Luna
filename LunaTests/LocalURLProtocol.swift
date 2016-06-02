//
//  LocalURLProtocol.swift
//  Luna
//
//  Created by Andrew Shepard on 4/13/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

class LocalURLProtocol: NSURLProtocol {
    
    override class func canInit(with request: NSURLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = self.client else { fatalError("Client is missing") }
        guard let url = request.url else { fatalError("URL is missing") }
        
        let data = self.dataForRequest(request)
        let headers = ["Content-Type": "application/json"]
        guard let response = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: headers) else {
            fatalError("Response could not be created")
        }
        
        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client.urlProtocol(self, didLoad: data)
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // all data return at once, nothing to do
    }
    
    private func dataForRequest(_ request: NSURLRequest) -> NSData {
        if let path = request.url?.path {
            var json: String?
            if path.range(of: "/sunmoon/moonphases/") != nil {
                json = NSBundle(for: self.dynamicType).pathForResource("moonphases", ofType: "json")
            }
            else if path.range(of: "/sunmoon/") != nil {
                json = NSBundle(for: self.dynamicType).pathForResource("sunmoon", ofType: "json")
            }
            
            if json != nil {
                let data = NSData(contentsOfFile: json!)
                return data!
            }
        }

        return NSData()
    }
}
