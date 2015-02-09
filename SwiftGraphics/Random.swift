//
//  Random.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

// MARK: Random Provider Protocol

import CoreGraphics

public protocol RandomProvider {
    func random() -> UInt32
    func random(uniform:UInt32) -> UInt32
    var max: UInt32 { get }
}

// MARK: Random

/**
 *  Defines a random number generator struct.
 *  This struct delegates the actual generation of random numbers to objects of RandomProvider protocol.
 *  This struct (and its extensions) provides lots of useful random utilities.
 */
public struct Random {

    public let provider: RandomProvider!

    public init(provider:RandomProvider) {
        self.provider = provider
    }

    public func random() -> UInt32 {
        return provider.random()
    }

    public func random(uniform:UInt32) -> UInt32 {
        return provider.random(uniform)
    }

    public func random(range:ClosedInterval<UInt32>) -> UInt32 {
        return random(range.end - range.start) + range.start
    }

    /// Default random number generator. Uses arc4random
    public static var rng: Random = Random(provider: Arc4RandomProvider())
}

// MARK: Ints

public extension Random {

    func random() -> Int {
        let value:UInt32 = random()
        return Int(value)
    }

    func random(uniform:Int) -> Int {
        assert(UInt32(uniform) <= provider.max && uniform >= 0)
        let value:UInt32 = random(UInt32(uniform))
        return Int(value)
    }

    func random(range:Range<Int>) -> Int {
        return random(range.endIndex - range.startIndex) + range.startIndex
    }
}


// MARK: Doubles

public extension Random {

    func random() -> Double {
        typealias Type = Double
        let value:UInt32 = random()
        return Type(value) / Type(provider.max)
    }

    func random(uniform:Double) -> Double {
        typealias Type = Double
        let value:UInt32 = random()
        return Type(value) / Type(provider.max - 1) * uniform
    }

    func random(range:ClosedInterval<Double>) -> Double {
        let r = random() * (range.end - range.start) + range.start
        return r
    }
}

// MARK: CG Types

public extension Random {

    func random() -> CGFloat {
        typealias Type = CGFloat
        let value:UInt32 = random()
        return Type(value) / Type(provider.max)
    }

    func random(uniform:CGFloat) -> CGFloat {
        typealias Type = CGFloat
        let value:UInt32 = random()
        return Type(value) / Type(provider.max - 1) * uniform
    }

    func random(range:ClosedInterval<CGFloat>) -> CGFloat {
        let r = random() * (range.end - range.start) + range.start
        return r
    }

    func random(range:CGRect) -> CGPoint {
        let r = CGPoint(
            x:range.origin.x + random() * range.size.width,
            y:range.origin.y + random() * range.size.height
        )
        return r
    }
}

// MARK: Arrays

public extension Random {

    func shuffle <T>(inout a:Array <T>) {
        //To shuffle an array a of n elements (indices 0..n-1):
        //  for i from 0 to n − 1 do
        //       j ← random integer with i ≤ j < n
        //       exchange a[j] and a[i]
        let n = a.count
        for i in 0..<n {
            let j = random(i..<n)
            (a[j], a[i]) = (a[i], a[j])
        }
    }

    func shuffled <T> (source:Array <T>) -> Array <T> {
        if source.count == 0 {
            return []
        }
        return random_array(source.count, initial:source[0]) { source[$0] }
    }

    func random_array <T> (count:Int, initial:T, block:Int -> T) -> Array <T> {
        //To initialize an array a of n elements to a randomly shuffled copy of source, both 0-based:
        //  for i from 0 to n − 1 do
        //      j ← random integer with 0 ≤ j ≤ i
        //      if j ≠ i
        //          a[i] ← a[j]
        //      a[j] ← source[i]
        if count == 0 {
            return []
        }
        var a = Array <T> (count:count, repeatedValue: initial)
        for i in 0 ..< count {
            let j = i > 0 ? random(0..<i) : 0
            if j != i {
                a[i] = a[j]
            }
            a[j] = block(i)
        }
        return a
    }
}

// MARK: Arc4RandomProvider

public struct Arc4RandomProvider: RandomProvider {
    public func random() -> UInt32 {
        return arc4random()
    }
    public func random(uniform:UInt32) -> UInt32 {
        return arc4random_uniform(uniform)
    }

    // From man-page: The arc4random() function returns pseudo-random pseudorandom random numbers in the range of 0 to (2**32)-1, and therefore has twice the range of rand(3) and random(3).
    public let max: UInt32 = 4294967295
}

// MARK: OS Random() RandomProvider

public struct SRandomProvider: RandomProvider {

    public var seed:UInt32 {
        didSet {
            srandom(seed)
        }
    }

    public init() {
        seed = arc4random()
    }

    public init(seed:UInt32) {
        self.seed = seed
    }

    public func random() -> UInt32 {
        return UInt32(random())
    }

    public func random(uniform:UInt32) -> UInt32 {
        switch uniform {
            case 0:
                return 0
            case 1:
                return 1
            case max:
                return random()
            default:
                let n = uniform
                let remainder = max % n
                var x:UInt32 = 0
                do {
                    x = random()
                }
                while x >= max - remainder
                return x % n
        }
    }

    // From man-page: "It returns successive pseudo-random numbers in the range from 0 to (2**31)-1"
    public let max: UInt32 = 2147483647
}

// MARK: Random array generator

/// Generate random points within the range.
public func arrayOfRandomPoints(count:Int, range:CGRect) -> [CGPoint] {
    return Array <CGPoint> (count:count) {
        return Random.rng.random(range)
    }
}
