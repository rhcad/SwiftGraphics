//
//  Lines.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/24/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: Line

public struct Line {
    let m:CGFloat
    let b:CGFloat

    // TODO: Vertical lines!?
    func lineSegment(x0  x0:CGFloat, x1:CGFloat) -> LineSegment {
        let start = CGPoint(x:x0, y:m * x0 + b)
        let end = CGPoint(x:x1, y:m * x1 + b)
        return LineSegment(start, end)
    }
}

// MARK: LineSegment

public struct LineSegment {
    // TODO: Convert to tuple
    public let start:CGPoint
    public let end:CGPoint

    public init(_ start:CGPoint, _ end:CGPoint) {
        self.start = start
        self.end = end
    }

    public var slope:CGFloat? {
        if end.x == start.x {
            return nil
        }
        return (end.y - start.y) / (end.x - start.x)
    }

    public var angle:CGFloat {
        return atan2(end - start)
    }

    public func isParallel(other:LineSegment) -> Bool {
        return slope == other.slope
    }

    public func intersection(other:LineSegment, clamped:Bool = true) -> CGPoint? {
        let x_1 = start.x
        let y_1 = start.y
        let x_2 = end.x
        let y_2 = end.y

        let x_3 = other.start.x
        let y_3 = other.start.y
        let x_4 = other.end.x
        let y_4 = other.end.y

        let denom = (x_1 - x_2) * (y_3 - y_4) - (y_1 - y_2) * (x_3 - x_4)
        if denom == 0.0 {
            return nil
        }

        let p1 = (x_1 * y_2 - y_1 * x_2)
        let p2 = (x_3 * y_4 - y_3 * x_4)
        let x = (p1 * (x_3 - x_4) - (x_1 - x_2) * p2) / denom
        let y = (p1 * (y_3 - y_4) - (y_1 - y_2) * p2) / denom

        let pt = CGPoint(x:x, y:y)

        if clamped {
            if containsPoint(pt) == false || other.containsPoint(pt) == false {
                return nil
            }
        }

        return pt
    }

    public func containsPoint(point:CGPoint) -> Bool {
        let a = start
        let b = end
        let c = point

        func within(p:CGFloat, q:CGFloat, r:CGFloat) -> Bool {
            // TODO: What about negatives?
            return q >= p && q <= r || q <= p && q >= r
        }
        return (collinear(a, b, c) && a.x != b.x) ? within(a.x, q: c.x, r: b.x) : within(a.y, q: c.y, r: b.y)
    }
}

// MARK: Line Chain

// TODO: Rename? Lines? Get rid of completely? #question #help-wanted
public struct LineChain {
    public let points:[CGPoint]

    public init(points:[CGPoint]) {
        self.points = points
    }
}

// MARK: Polygon

public struct Polygon {
    public let points:[CGPoint]

    public init(points:[CGPoint]) {
        self.points = points
    }
}