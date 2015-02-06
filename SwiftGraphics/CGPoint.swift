//
//  CGPoint.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: CGPoint

extension CGPoint: Printable {
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

public func + (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs.x + rhs.x, y:lhs.y + rhs.y)
}

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

    var isZero: Bool {
        get {
            return x == 0 && y == 0
        }
    }

    func clamped(rect:CGRect) -> CGPoint {
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

public func floor(value:CGPoint) -> CGPoint {
    return value.map { floor($0) }
}

public func ceil(value:CGPoint) -> CGPoint {
    return value.map { ceil($0) }
}

public func round(value:CGPoint) -> CGPoint {
    return value.map { round($0) }
}

public func round(value:CGPoint, decimal:Int) -> CGPoint {
    return value.map { round($0, decimal) }
}

