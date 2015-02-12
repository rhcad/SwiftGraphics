//
//  Private.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// Utility code that is used by SwiftGraphics but isn't intended to be used outside of this project

/**
 :example:
    let (a,b) = ordered(("B", "A"))
 */
func ordered <T:Comparable> (tuple:(T, T)) -> (T, T) {
    let (lhs, rhs) = tuple
    if lhs <= rhs {
        return (lhs, rhs)
    }
    else {
        return (rhs, lhs)
    }
}


extension Array {
    init(count:Int, @noescape block:(Void) -> T) {
        self.init()
        for N in 0..<count {
            self.append(block())
        }
    }

    mutating func push(o:T) {
        append(o)
    }
    mutating func pop() -> T? {
        if let first = first {
            removeAtIndex(0)
            return first
        }
        return nil
    }
}



/**
 *  Generator that "walks" through another generator two elements at a time.
 */
struct SlidingWindow <T>: GeneratorType {
    typealias Element = (T, T?)

    var g: Array<T>.Generator
    var e: T?

    init(_ a:Array <T>) {
        g = a.generate()
        e = g.next()
    }

    mutating func next() -> Element? {
        if e == nil {
            return nil
        }

    let next = g.next()
    let result = (e!, next)
    e = next

    return result
    }
}

// MARK: Comparing

func compare <T:Comparable> (lhs:T, rhs:T) -> Int {
    return lhs == rhs ? 0 : (lhs > rhs ? 1 : -1)
}


