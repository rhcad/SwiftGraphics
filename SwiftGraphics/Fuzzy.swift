//
//  Fuzzy.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK:

public func equal(lhs:CGFloat, _ rhs:CGFloat, accuracy:CGFloat) -> Bool {
    return abs(rhs - lhs) <= accuracy
}

public func equal(lhs:Float, _ rhs:Float, accuracy:Float) -> Bool {
    return abs(rhs - lhs) <= accuracy
}

public func equal(lhs:Double, _ rhs:Double, accuracy:Double) -> Bool {
    return abs(rhs - lhs) <= accuracy
}


// MARK: Fuzzy equality

public protocol FuzzyEquatable {
    func ==%(lhs: Self, rhs: Self) -> Bool
}

infix operator ==% { associativity none precedence 130 }

// MARK: Fuzzy inequality

infix operator !=% { associativity none precedence 130 }

public func !=% <T:FuzzyEquatable> (lhs:T, rhs:T) -> Bool {
    return !(lhs ==% rhs)
}

// MARK: Float

extension Float: FuzzyEquatable {
}

public func ==% (lhs:Float, rhs:Float) -> Bool {
    let epsilon = Float(FLT_EPSILON) // TODO: FLT vs DBL
    return equal(lhs, rhs, accuracy:epsilon)
}

// MARK: Double

extension Double: FuzzyEquatable {
}

public func ==% (lhs:Double, rhs:Double) -> Bool {
    let epsilon = Double(FLT_EPSILON) // TODO: FLT vs DBL
    return equal(lhs, rhs, accuracy:epsilon)
}

// Mark: CGFloat

extension CGFloat: FuzzyEquatable {
}

public func ==% (lhs:CGFloat, rhs:CGFloat) -> Bool {
    let epsilon = CGFloat(FLT_EPSILON) // TODO: FLT vs DBL
    return equal(lhs, rhs, accuracy:epsilon)
}

// MARK: CGPoint

extension CGPoint: FuzzyEquatable {
}

public func ==% (lhs:CGPoint, rhs:CGPoint) -> Bool {
    return (lhs - rhs).isZero
}

