//
//  Reachable.swift
//  Luna
//
//  Created by Andrew Shepard on 12/7/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import SystemConfiguration

public enum ReachabilityType {
    case online
    case offline
}

protocol Reachable {
    var reachable: ReachabilityType { get }
}

extension Reachable {
    var reachable: ReachabilityType {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        
        var reachability: ReachabilityType = ReachabilityType.offline
        
        let _ = withUnsafePointer(to: &address, { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, { (addr) -> Void in
                guard let reachable = SCNetworkReachabilityCreateWithAddress(nil, addr) else { return }
        
                var flags: SCNetworkReachabilityFlags = []
                if !SCNetworkReachabilityGetFlags(reachable, &flags) { return }
                
                reachability = ReachabilityType(reachabilityFlags: flags)
            })
        })
        
        return reachability
    }
}

extension ReachabilityType {
    public init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        self = (!connectionRequired && isReachable) ? .online : .offline
    }
}

extension ReachabilityType: CustomDebugStringConvertible  {
    public var debugDescription: String {
        switch self {
            case .online:
                return "Online"
            case .offline:
                return "Offline"
        }
    }
}
