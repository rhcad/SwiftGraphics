//
//  CGPoint.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: CGPoint

extension CGPoint : Printable {
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
    var asTuple : (CGFloat, CGFloat) { get { return (x, y) } }
}

// MARK: Arithmetic

public prefix func + (p:CGPoint) -> CGPoint {
    return p
}

public prefix func - (p:CGPoint) -> CGPoint {
    return CGPoint(x:-p.x, y:-p.y)
}

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

// MARK: Arithmetic (with scalar of CGSize)

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

public extension CGPoint {
    var asSize : CGSize { get { return CGSize(w:x, h:y) } }
}

// MARK: dotProduct and crossProduct

public extension CGPoint {
    func dotProduct(v:CGPoint) -> CGFloat {
        return x * v.x + y * v.y
    }

    func crossProduct(v:CGPoint) -> CGFloat {
        return x * v.y - y * v.x
    }
}

// MARK: Misc

public extension CGPoint {
    func clamped(rect:CGRect) -> CGPoint {
        return CGPoint(
            x:clamp(x, rect.minX, rect.maxX),
            y:clamp(y, rect.minY, rect.maxY)
        )
    }
}

// MARK: Trig

public extension CGPoint {

    init(magnitude:CGFloat, direction:CGFloat) {
        x = cos(direction) * magnitude
        y = sin(direction) * magnitude
    }

    var magnitude : CGFloat {
        get {
            return sqrt(x ** 2 + y ** 2)
        }
        set(v) {
            self = CGPoint(magnitude:v, direction:direction)
        }
    }

    var direction : CGFloat {
        get {
            return atan2(self)
        }
        set(v) {
            self = CGPoint(magnitude:magnitude, direction:v)
        }
    }

    var square : CGFloat {
        get {
            return x ** 2 + y ** 2
        }
    }

    var normalized : CGPoint { get {
        let len = magnitude
        return len ==% 0 ? self : CGPoint(x:x / len, y:y / len)
        }}

    var orthogonal : CGPoint {
        get {
            return CGPoint(x:-y, y:x)
        }
    }

    var isZero: Bool {
        get {
            return x == 0 && y == 0
        }
    }

    // TODO: It might be better to remove this and let users use ==% CGPointZero
    var isFuzzyZero: Bool {
        get {
            return self ==% CGPointZero
        }
    }
}

public func atan2(point:CGPoint) -> CGFloat {   // (-M_PI, M_PI]
    return atan2(point.y, point.x)
}


public extension CGPoint {
    func map(transform: CGFloat -> CGFloat) -> CGPoint {
        return CGPoint(x:transform(x), y:transform(y))
    }
}

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

// MARK: Distance and angle between two points or vectors

public extension CGPoint {

    func distanceTo(point:CGPoint) -> CGFloat {
        return (self - point).magnitude
    }
    
    func distanceTo(p1:CGPoint, p2:CGPoint) -> CGFloat {
        return distanceToBeeline(p1, p2:p2).0
    }
    
    func distanceToBeeline(p1:CGPoint, p2:CGPoint) -> (CGFloat, CGPoint) {
        if p1 == p2 {
            return (distanceTo(p1), p1)
        }
        if p1.x == p2.x {
            return (abs(p1.x - self.x), CGPoint(x:p1.x, y:self.y))
        }
        if p1.y == p2.y {
            return (abs(p1.y - self.y), CGPoint(x:self.x, y:p1.y))
        }
        
        let t1 = (p2.y - p1.y) / (p2.x - p1.x)
        let t2 = -1 / t1
        let numerator = self.y - p1.y + p1.x * t1 - self.x * t2
        let perpx = numerator / (t1 - t2)
        let perp = CGPoint(x: perpx, y: p1.y + (perpx - p1.x) * t1)
        
        return (distanceTo(perp), perp)
    }

    func angleTo(vec:CGPoint) -> CGFloat {       // [-M_PI, M_PI)
        return atan2(crossProduct(vec), dotProduct(vec))
    }
}

// MARK: Equatable

extension CGPoint : FuzzyEquatable {
}

public func ==% (lhs:CGPoint, rhs:CGPoint) -> Bool {
    return (lhs - rhs).isZero
}

/**
 Return true if a, b, and c all lie on the same line.
 */
public func collinear(a:CGPoint, b:CGPoint, c:CGPoint) -> Bool {
    return (b.x - a.x) * (c.y - a.y) ==% (c.x - a.x) * (b.y - a.y)
}

/**
 Return true if c is near to the beeline a b.
 */
public func collinear(a:CGPoint, b:CGPoint, c:CGPoint, tol:CGFloat) -> Bool {
    return c.distanceTo(a, p2:b) <= tol
}

/**
 Return the included angle between vertex-p1 and vertex-vertex.
 */
public func angle(vertex:CGPoint, p1:CGPoint, p2:CGPoint) -> CGFloat {
    return abs((p1 - vertex).angleTo(p2 - vertex))
}
