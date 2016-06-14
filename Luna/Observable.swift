//
//  Observable.swift
//  Luna
//
//  Created by Andrew Shepard on 3/23/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

protocol ObservableType {
    associatedtype Value
    var value: Value { get set }
    
    func subscribe(observer: AnyObject, change: (Value) -> ())
    func unsubscribe(observer: AnyObject)
}

public final class Observable<T>: ObservableType {
    typealias Change = (value: T) -> ()
    typealias Observer = (object: AnyObject, change: Change)
    
    private var observers: [Observer]
    
    init(_ value: T) {
        self.value = value
        self.observers = []
    }
    
    var value: T {
        didSet {
            observers.forEach { (observer: Observer) in
                let (_, change) = observer
                change(value: value)
            }
        }
    }
    
    func subscribe(object: AnyObject, change: (T) -> ()) {
        let entry: Observer = (object: object, change: change)
        observers.append(entry)
    }
    
    func unsubscribe(object: AnyObject) {
        let filtered = observers.filter { observer in
            let (obj, _) = observer
            return obj !== object
        }
        
        observers = filtered
    }
}
