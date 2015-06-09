//
//  CGPoint.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: CGPoint

extension CGPoint: CustomStringConvertible {
    public var description: String { get { return "\(x), \(y)" } }
}

// MARK: Convenience initializers

public extension CGPoint {
    
    init(x:CGFloat) {
        self.x = x
        self.y = 0
    }

    init(y:CGFloat) {
        self.x = 0
        self.y = y
    }
}

// MARK: Converting to/from tuples

public extension CGPoint {
    init(_ v:(CGFloat, CGFloat)) {
        (x, y) = v
    }
    var asTuple: (CGFloat, CGFloat) { get { return (x, y) } }
}

// MARK: Unary Operators

public prefix func + (p:CGPoint) -> CGPoint {
    return p
}

public prefix func - (p:CGPoint) -> CGPoint {
    return CGPoint(x:-p.x, y:-p.y)
}

// MARK: Arthimetic Operators

/**
 Addition operator (CGPoint + CGPoint)

 :test:   CGPoint(x:1, y:2) + CGPoint(x:10, y:20)
 :result: CGPoint(x:11, y:22)
 */
public func + (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs.x + rhs.x, y:lhs.y + rhs.y)
}

/**
 Subtraction operator (CGPoint - CGPoint)

 :test:   CGPoint(x:11, y:22) - CGPoint(x:10, y:20)
 :result: CGPoint(x:1, y:2)
 */
public func - (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs.x - rhs.x, y:lhs.y - rhs.y)
}

// MARK: Arithmetic (with scalar)

public func * (lhs:CGPoint, rhs:CGFloat) -> CGPoint {
    return CGPoint(x:lhs.x * rhs, y:lhs.y * rhs)
}

public func * (lhs:CGFloat, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs * rhs.x, y:lhs * rhs.y)
}

public func / (lhs:CGPoint, rhs:CGFloat) -> CGPoint {
    return CGPoint(x:lhs.x / rhs, y:lhs.y / rhs)
}

// MARK: Arithmetic Assignment

public func += (inout lhs:CGPoint, rhs:CGPoint) {
    lhs = lhs + rhs
}

public func -= (inout lhs:CGPoint, rhs:CGPoint) {
    lhs = lhs - rhs
}

public func *= (inout lhs:CGPoint, rhs:CGFloat) {
    lhs = lhs * rhs
}

public func /= (inout lhs:CGPoint, rhs:CGFloat) {
    lhs = lhs / rhs
}

// MARK: Arithmetic (with CGSize)

public func * (lhs:CGPoint, rhs:CGSize) -> CGPoint {
    return CGPoint(x:lhs.x * rhs.width, y:lhs.y * rhs.height)
}

public func / (lhs:CGPoint, rhs:CGSize) -> CGPoint {
    return CGPoint(x:lhs.x / rhs.width, y:lhs.y / rhs.height)
}

public func *= (inout lhs:CGPoint, rhs:CGSize) {
    lhs = lhs * rhs
}

public func /= (inout lhs:CGPoint, rhs:CGSize) {
    lhs = lhs / rhs
}

// MARK: Misc

public extension CGPoint {

    /**
     :test:   CGPoint(x:0, y:0).isZero
     :result: true
     :test:   CGPoint(x:1, y:0).isZero
     :result: false
     */
    var isZero: Bool {
        get {
            return x == 0 && y == 0
        }
    }

    /**
     :test:   CGPoint(x:50, y:50).clampedTo(CGRect(x:10, y:20, w:100, h:100))
     :result: CGPoint(x:50, y:50)
     :test:   CGPoint(x:150, y:50).clampedTo(CGRect(x:10, y:20, w:100, h:100))
     :result: CGPoint(x:110, y:50)
     :test:   CGPoint(x:0, y:50).clampedTo(CGRect(x:10, y:20, w:100, h:100))
     :result: CGPoint(x:10, y:50)
     :test:   CGPoint(x:50, y:00).clampedTo(CGRect(x:10, y:20, w:100, h:100))
     :result: CGPoint(x:50, y:20)
     */
    func clampedTo(rect:CGRect) -> CGPoint {
        return CGPoint(
            x:clamp(x, rect.minX, rect.maxX),
            y:clamp(y, rect.minY, rect.maxY)
        )
    }

    func map(transform: CGFloat -> CGFloat) -> CGPoint {
        return CGPoint(x:transform(x), y:transform(y))
    }
}

public extension CGPoint {
    init(size:CGSize) {
        self.x = size.width
        self.y = size.height
    }
}


// MARK: Rounding

/**
 :test:   floor(CGPoint(x:10.9, y:-10.5))
 :result: CGPoint(x:10, y:-11)
*/
public func floor(value:CGPoint) -> CGPoint {
    return value.map(floor)
}

/**
 :test:   ceil(CGPoint(x:10.9, y:-10.5))
 :result: CGPoint(x:11, y:-10)
*/
public func ceil(value:CGPoint) -> CGPoint {
    return value.map(ceil)
}

/**
 :test:   round(CGPoint(x:10.9, y:-10.6))
 :result: CGPoint(x:11, y:-11)
*/
public func round(value:CGPoint) -> CGPoint {
    return value.map(round)
}

/**
 :test:   floor(CGPoint(x:10.09, y:-10.95))
 :result: CGPoint(x:10, y:-11)
*/
public func round(value:CGPoint, _ decimal:Int) -> CGPoint {
    return value.map { round($0, decimal: decimal) }
}

