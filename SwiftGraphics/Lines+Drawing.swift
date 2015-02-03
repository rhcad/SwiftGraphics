//
//  Lines+Drawing.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/24/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

extension Line : Geometry {

    public var frame:CGRect {
        get {
            return CGRectInfinite
        }
    }

    public func drawInContext(context: CGContextRef) {
        // TODO: Hack
        let segment = lineSegment(x0: -100000.0, x1: 100000.0)
        segment.drawInContext(context)
    }
}

extension LineSegment: Geometry, Drawable {
    public var frame:CGRect {
        get {
            return CGRect(points:(start, end))
        }
    }

    public func drawInContext(context: CGContextRef) {
        context.strokeLine(start, end)
    }
}

extension LineChain : Geometry, Drawable {
    public var frame:CGRect {
        get {
            return CGRect.unionOfPoints(points)
        }
    }

    public func drawInContext(context: CGContextRef) {
        context.strokeLine(points, closed:false)
    }
}

extension Polygon : Geometry, Drawable {
    public var frame:CGRect {
        get {
            return CGRect.unionOfPoints(points)
        }
    }

    public func drawInContext(context: CGContextRef) {
        context.strokeLine(points, closed:true)
    }
}