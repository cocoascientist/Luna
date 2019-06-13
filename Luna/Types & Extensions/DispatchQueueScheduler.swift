//
//  DispatchQueueScheduler.swift
//  Luna
//
//  Created by Andrew Shepard on 6/12/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import Combine

// https://github.com/marty-suzuki/GitHubSearchWithSwiftUI

struct DispatchQueueScheduler: Scheduler {
    
    static var main: DispatchQueueScheduler {
        return DispatchQueueScheduler(queue: DispatchQueue.main)
    }
    
    var now: DispatchTime {
        return DispatchTime.now()
    }
    
    var minimumTolerance: Int {
        return 0
    }
    
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    func schedule(options: Never?, _ action: @escaping () -> Void) {
        queue.async(execute: action)
    }
    
    func schedule(after date: DispatchTime,
                  tolerance: Int,
                  options: Never?,
                  _ action: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(tolerance),
                         execute: action)
    }
    
    func schedule(after date: DispatchTime,
                  interval: Int,
                  tolerance: Int,
                  options: Never?,
                  _ action: @escaping () -> Void) -> Cancellable {
        let workItem = DispatchWorkItem(block: action)
        queue.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(interval),
                         execute: workItem)
        return AnyCancellable { workItem.cancel() }
    }
}

extension DispatchTime: Strideable {
    
    public func advanced(by n: Int) -> DispatchTime {
        return self + DispatchTimeInterval.seconds(Int.seconds(n))
    }
    
    public func distance(to other: DispatchTime) -> Int {
        return Int((other.uptimeNanoseconds - uptimeNanoseconds) / 1000000)
    }
}

extension Int: SchedulerTimeIntervalConvertible {
    
    public static func seconds(_ s: Int) -> Int {
        return s * 1000
    }
    
    public static func seconds(_ s: Double) -> Int {
        return Int(s) * 1000
    }
    
    public static func milliseconds(_ ms: Int) -> Int {
        return ms
    }
    
    public static func microseconds(_ us: Int) -> Int {
        return us / 1000
    }
    
    public static func nanoseconds(_ ns: Int) -> Int {
        return ns / 1000000
    }
}
