//
//  GeometryExtensions.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/3/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

import SwiftUtilities

// MARK: -

public protocol CGPathable {
    var cgpath:CGPath { get }
}

// TODO: Rename to Intersectionable? ICK
public protocol HitTestable {
    func contains(point:CGPoint) -> Bool
    func intersects(rect:CGRect) -> Bool
    func intersects(path:CGPath) -> Bool
}

// MARK: -

extension Rectangle: CGPathable {
    public var cgpath:CGPath {
        return CGPathCreateWithRect(frame, nil)
    }
}

extension Circle: CGPathable {
    public var cgpath:CGPath {
        return CGPathCreateWithEllipseInRect(frame, nil)
    }
}

extension Ellipse: CGPathable {
    public var cgpath:CGPath {
        let path = CGPathCreateMutable()
        let (b1, b2, b3, b4) = self.toBezierCurves
        
        path.move(b1.start!)
        path.addCurve(BezierCurve(controls: b1.controls, end: b1.end))
        path.addCurve(BezierCurve(controls: b2.controls, end: b2.end))
        path.addCurve(BezierCurve(controls: b3.controls, end: b3.end))
        path.addCurve(BezierCurve(controls: b4.controls, end: b4.end))
        path.close()
        return path
    }
}

extension Triangle: CGPathable {
    public var cgpath:CGPath {
        let path = CGPathCreateMutable()
        path.move(points.0)
        path.addLine(points.1)
        path.addLine(points.2)
        path.close()
        return path
    }
}

extension SwiftGraphics.Polygon: CGPathable {
    public var cgpath:CGPath {
        let path = CGPathCreateMutable()
        path.move(points[0])
        for point in points[1..<points.count] {
            path.addLine(point)
        }
        path.close()
        return path
    }
}

// MARK: -

extension Rectangle: HitTestable {
    public func contains(point:CGPoint) -> Bool {
        return frame.contains(point)
    }

    public func intersects(rect:CGRect) -> Bool {
        return frame.intersects(rect)
    }

    public func intersects(path:CGPath) -> Bool {
        return path.intersects(frame)
    }
}

extension Circle: HitTestable {
    public func contains(point:CGPoint) -> Bool {
        if self.frame.contains(point) {
            return (center - point).magnitudeSquared < radius ** 2
        }
        else {
            return false
        }
    }

    public func intersects(rect:CGRect) -> Bool {
        // TODO: BROKEN!?

        // http://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection
        let circleDistance_x = abs(center.x - rect.origin.x);
        let circleDistance_y = abs(center.y - rect.origin.y);

        let half_width = rect.size.width / 2
        let half_height = rect.size.height / 2

        if circleDistance_x > half_width + radius {
            return false
        }
        if circleDistance_y > half_height + radius {
            return false
        }

        if circleDistance_x <= half_width {
            return true
        }
        if circleDistance_y <= half_height {
            return true
        }

        let cornerDistance_sq = ((circleDistance_x - half_width) ** 2) + ((circleDistance_y - half_height) ** 2)

        return cornerDistance_sq <= (radius ** 2)
    }

    public func intersects(path:CGPath) -> Bool {
        return cgpath.intersects(path)
    }

    public func intersects(lineSegment:LineSegment) -> Bool {
        let Ax = lineSegment.start.x
        let Ay = lineSegment.start.y
        let Bx = lineSegment.end.x
        let By = lineSegment.end.y
        let Cx = center.x
        let Cy = center.y

        // compute the triangle area times 2 (area = area2/2)
        let area2 = (Bx-Ax) * (Cy-Ay) - (Cx-Ax) * (By-Ay)
        let abs_area2 = abs(area2)

        // compute the AB segment length
        let LAB = sqrt((Bx-Ax) ** 2 + (By-Ay) ** 2)

        // compute the triangle height
        let h = abs_area2 / LAB

        let R = radius

        return h < R
    }
}

extension Triangle: HitTestable {
    public func contains(point:CGPoint) -> Bool {
        // http://totologic.blogspot.fr/2014/01/accurate-point-in-triangle-test.html

        // Compute vectors
        let v0 = points.2 - points.0
        let v1 = points.1 - points.0
        let v2 = point - points.0

        // Compute dot products
        let dot00 = dotProduct(v0, v0)
        let dot01 = dotProduct(v0, v1)
        let dot02 = dotProduct(v0, v2)
        let dot11 = dotProduct(v1, v1)
        let dot12 = dotProduct(v1, v2)

        // Compute barycentric coordinates
        let invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
        let u = (dot11 * dot02 - dot01 * dot12) * invDenom
        let v = (dot00 * dot12 - dot01 * dot02) * invDenom

        // Check if point is in triangle
        return (u >= 0) && (v >= 0) && (u + v < 1)
    }

    public func intersects(rect:CGRect) -> Bool {
        return self.cgpath.intersects(rect)
    }

    public func intersects(path:CGPath) -> Bool {
        return cgpath.intersects(path)
    }
}
