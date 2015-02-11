//
//  Geometry+CGPathable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/3/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

extension Rectangle: CGPathable {
    public var cgpath:CGPath {
        get {
            return CGPathCreateWithRect(frame, nil)
        }
    }
}

extension Circle: CGPathable {
    public var cgpath:CGPath {
        get {
            return CGPathCreateWithEllipseInRect(frame, nil)
        }
    }
}

extension Ellipse: CGPathable {
    public var cgpath:CGPath {
        get {
            let path = CGPathCreateMutable()
            let (b1, b2, b3, b4) = self.asBezierCurves
            
            path.move(b1.start!)
            path.addCurve(BezierCurve(controls: b1.controls, end: b1.end))
            path.addCurve(BezierCurve(controls: b2.controls, end: b2.end))
            path.addCurve(BezierCurve(controls: b3.controls, end: b3.end))
            path.addCurve(BezierCurve(controls: b4.controls, end: b4.end))
            path.close()
            return path
        }
    }
}

extension Triangle: CGPathable {
    public var cgpath:CGPath {
        get {
            var path = CGPathCreateMutable()
            path.move(points.0)
            path.addLine(points.1)
            path.addLine(points.2)
            path.close()
            return path
        }
    }
}

extension Polygon: CGPathable {
    public var cgpath:CGPath {
        get {
            var path = CGPathCreateMutable()
            path.move(points[0])
            for point in points[1..<points.count] {
                path.addLine(point)
            }
            path.close()
            return path
        }
    }
}
