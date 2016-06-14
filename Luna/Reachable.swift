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
        address.sin_len = UInt8(sizeofValue(address))
        address.sin_family = sa_family_t(AF_INET)
        
        guard let reachable = withUnsafePointer(&address, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return ReachabilityType.offline
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(reachable, &flags) {
            return ReachabilityType.offline
        }
        
        return ReachabilityType(reachabilityFlags: flags)
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
            case .online(let type):
                return "Online (\(type))"
            case .offline:
                return "Offline"
        }
    }
}
