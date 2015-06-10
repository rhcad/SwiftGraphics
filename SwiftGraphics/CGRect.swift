//
//  CGRect.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: CGRect

public extension CGRect {
    init(size:CGSize) {
        self.origin = CGPointZero
        self.size = size
    }
    
    init(width:CGFloat, height:CGFloat) {
        self.origin = CGPointZero
        self.size = CGSize(width:width, height:height)
    }

    init(x:CGFloat, y:CGFloat, w width:CGFloat, h height:CGFloat) {
        self.origin = CGPoint(x:x, y:y)
        self.size = CGSize(width:width, height:height)
    }

    init(w width:CGFloat, h height:CGFloat) {
        self.origin = CGPointZero
        self.size = CGSize(width:width, height:height)
    }

    // TODO: Deprecate in favour of init(points:(CGPoint, CGPoint)) #deprecate #simplify
    init(p1:CGPoint, p2:CGPoint) {
        self.origin = CGPoint(x:min(p1.x, p2.x), y:min(p1.y, p2.y))
        self.size = CGSize(width:abs(p2.x - p1.x), height:abs(p2.y - p1.y))
    }

    init(points:(CGPoint, CGPoint)) {
        self.origin = CGPoint(x:min(points.0.x, points.1.x), y:min(points.0.y, points.1.y))
        self.size = CGSize(width:abs(points.1.x - points.0.x), height:abs(points.1.y - points.0.y))
    }

    init(center:CGPoint, size:CGSize) {
        self.origin = CGPoint(x:center.x - size.width * 0.5, y:center.y - size.height * 0.5)
        self.size = size
    }

    init(center:CGPoint, radius:CGFloat) {
        self.origin = CGPoint(x:center.x - radius, y:center.y - radius)
        self.size = CGSize(width:radius * 2, height:radius * 2)
    }

    init(center:CGPoint, diameter:CGFloat) {
        self.origin = CGPoint(x:center.x - diameter * 0.5, y:center.y - diameter * 0.5)
        self.size = CGSize(width:diameter, height:diameter)
    }

    init(minX:CGFloat, minY:CGFloat, maxX:CGFloat, maxY:CGFloat) {
        self = CGRect(points:(CGPoint(x:minX, y:minY), CGPoint(x:maxX, y:maxY)))
    }
}

public func * (lhs:CGRect, rhs:CGFloat) -> CGRect {
    return CGRect(origin:lhs.origin * rhs, size:lhs.size * rhs)
}

public func * (lhs:CGFloat, rhs:CGRect) -> CGRect {
    return CGRect(origin:lhs * rhs.origin, size:lhs * rhs.size)
}

public extension CGRect {

    var mid: CGPoint {
        get {
            return midXMidY
        }
    }

    var minXMinY: CGPoint {
        get {
            return CGPoint(x:minX, y:minY)
        }
        set {
            self = CGRect(p1:minXMinY, p2:maxXMaxY)
        }
    }

    var minXMidY: CGPoint {
        get {
            return CGPoint(x:minX, y:midY)
        }
    }
    var minXMaxY: CGPoint {
        get {
            return CGPoint(x:minX, y:maxY)
        }
        set {
            self = CGRect(p1:minXMaxY, p2:maxXMinY)
        }
    }

    var midXMinY: CGPoint {
        get {
            return CGPoint(x:midX, y:minY)
        }
    }

    var midXMidY: CGPoint {
        get {
            return CGPoint(x:midX, y:midY)
        }
    }

    var midXMaxY: CGPoint {
        get {
            return CGPoint(x:midX, y:maxY)
        }
    }

    var maxXMinY: CGPoint {
        get {
            return CGPoint(x:maxX, y:minY)
        }
        set {
            self = CGRect(p1:maxXMinY, p2:minXMaxY)
        }
    }

    var maxXMidY: CGPoint {
        get {
            return CGPoint(x:maxX, y:midY)
        }
    }

    var maxXMaxY: CGPoint {
        get {
            return CGPoint(x:maxX, y:maxY)
        }
        set {
            self = CGRect(p1:maxXMaxY, p2:minXMinY)
        }
    }
}

// MARK: Misc. CGRect utilities.

public extension CGRect {

    func offsetBy(dx  dx:CGFloat, dy:CGFloat) -> CGRect {
        var copy = self
        copy.offset(dx: dx, dy: dy)
        return copy
    }

    func offsetBy(delta:CGPoint) -> CGRect {
        var copy = self
        copy.offset(dx: delta.x, dy: delta.y)
        return copy
    }

    func insetBy(dx  dx:CGFloat, dy:CGFloat) -> CGRect {
        var copy = self
        copy.inset(dx:dx, dy:dy)
        return copy
        }

    // TODO: Deprecate
    func insetted(dx  dx:CGFloat, dy:CGFloat) -> CGRect {
        var copy = self
        copy.inset(dx:dx, dy:dy)
        return copy
        }


    var isFinite: Bool {
        get {
            return CGRectIsNull(self) == false && CGRectIsInfinite(self) == false
        }
    }

    static func unionOfRects(rects:[CGRect]) -> CGRect {
        var result = rects[0]
        for rect in rects[1..<rects.count] {
            result.union(rect)
        }
        return result
    }
    
    static func unionOfPoints(points:[CGPoint]) -> CGRect {
        if points.isEmpty {
            return CGRect.nullRect
        }
        var result = CGRect(center:points[0], radius:0.0)
        for pt in points[1..<points.count] {
            result.union(pt)
        }
        return result
    }
    
    func rectByUnion(point: CGPoint) -> CGRect {
        return rectByUnion(CGRect(center:point, radius:0.0))
    }
    
    mutating func union(point: CGPoint) {
        union(CGRect(center:point, radius:0.0))
    }

    var toTuple: (CGFloat, CGFloat, CGFloat, CGFloat) { get { return (origin.x, origin.y, size.width, size.height) } }

    func integral() -> CGRect {
        return CGRectIntegral(self)
    }

    func partiallyIntersects(other:CGRect) -> Bool {
        if CGRectIntersectsRect(self, other) == true {
            let union = CGRectUnion(self, other)
            if CGRectEqualToRect(self, union) == false {
                return true
            }
        }
        return false
    }

}


