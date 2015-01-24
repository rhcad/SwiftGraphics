//
//  Geometry+Drawable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

extension CGPoint : Geometry {
    public var frame:CGRect { get { return CGRect(center:self, diameter:0) } }
}

extension CGPoint : Drawable {
    public func drawInContext(ctx:CGContext) {
        ctx.plotPoints([self])
    }
}

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

extension Circle : Drawable {
    public func drawInContext(ctx:CGContext) {
        ctx.strokeEllipseInRect(frame)
    }
}

extension Triangle : Drawable {
    public func drawInContext(ctx:CGContext) {
        let (a,b,c) = points
        ctx.strokeLine([a, b, c], close:true)
    }
    public var frame : CGRect {
        get {
            let (a,b,c) = self.points
            let points = [a,b,c]
            let rects:[CGRect] = points.map {
                return $0.frame
            }
            return CGRect.unionOfRects(rects)
        }
    }
}


public struct Saltire {
    public let frame:CGRect

    public init(frame:CGRect) {
        self.frame = frame
    }
}

extension Saltire: Drawable {
    public func drawInContext(context:CGContext) {
        context.strokeSaltire(frame)
    }
}

extension RegularPolygon: Drawable {

    public var frame:CGRect {
        get {
            return self.circumcircle.frame
        }
    }

    public func drawInContext(context: CGContext) {
        let path = Path(vertices:points, closed:true)
        let mode = CGPathDrawingMode(strokeColor:context.strokeColor, fillColor:context.fillColor)
        CGContextAddPath(context, path.CGPath)
        CGContextDrawPath(context, mode)
    }
}

