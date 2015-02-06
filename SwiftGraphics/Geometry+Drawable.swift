//
//  Geometry+Drawable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: CGPoint

extension CGPoint: Geometry {
    public var frame:CGRect { get { return CGRect(center:self, diameter:0) } }
}

extension CGPoint: Drawable {
    public func drawInContext(ctx:CGContext) {
        ctx.plotPoints([self])
    }
}

// MARK: BezierCurve

extension BezierCurve: Drawable {

    public var frame:CGRect {
        get {
            return self.boundingBox
        }
    }

    public func drawInContext(context:CGContext) {
        context.stroke(self)
    }
}

// MARK: Circle

extension Circle: Drawable {
    public func drawInContext(context:CGContext) {
        CGContextAddEllipseInRect(context, self.frame)
        let mode = CGPathDrawingMode(strokeColor:context.strokeColor, fillColor:context.fillColor)
        CGContextDrawPath(context, mode)
    }
}

// MARK: Triangle

extension Triangle: Drawable {
    public func drawInContext(context:CGContext) {
        let path = CGPathCreateMutable()
        let points = pointsArray
        path.move(pointsArray[0])
        path.addLines(pointsArray)
        path.close()
        let mode = CGPathDrawingMode(strokeColor:context.strokeColor, fillColor:context.fillColor)
        CGContextAddPath(context, path)
        CGContextDrawPath(context, mode)
    }
}

// MARK: Saltire

//extension Saltire: Drawable {
//    public func drawInContext(context:CGContext) {
//        context.strokeSaltire(frame)
//    }
//}

extension RegularPolygon: Drawable {

    public var frame:CGRect {
        get {
            return self.circumcircle.frame
        }
    }

    public func drawInContext(context: CGContext) {
        let path = CGPathCreateMutable()
        path.move(points[0])
        path.addLines(points)
        path.close()
        let mode = CGPathDrawingMode(strokeColor:context.strokeColor, fillColor:context.fillColor)
        CGContextAddPath(context, path)
        CGContextDrawPath(context, mode)
    }
}

