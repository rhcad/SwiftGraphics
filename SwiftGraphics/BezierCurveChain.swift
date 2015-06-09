//
//  BezierCurveChain.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public struct BezierCurveChain {

    // TODO: This isn't really an accurate representaiton of what we want.
    // TODO: Control points should be shared (and mirrored) between neighbouring curves.
    public let curves:[BezierCurve]

    public init(curves:[BezierCurve]) {

        var previousCurve:BezierCurve?
        self.curves = curves.map() {
            (curve:BezierCurve) -> BezierCurve in

            var newCurve = curve
            if let previousEndPoint = previousCurve?.end {
                if let start = curve.start {
                    assert(previousEndPoint == start)
                    newCurve = BezierCurve(controls:curve.controls, end:curve.end)
                }
            }

            previousCurve = curve
            return newCurve
        }
    }
}

extension BezierCurveChain: CustomStringConvertible {
    public var description: String {
        get {
            return ", ".join(curves.map() { $0.description })
        }
    }
}


extension BezierCurveChain: Drawable {

    public func drawInContext(context:CGContextRef) {

        // Stroke all curves as a single path
        let start = curves[0].start
        CGContextMoveToPoint(context, start!.x, start!.y)
        for curve in curves {
            context.addToPath(curve)
        }
        CGContextStrokePath(context)
    }
}

// TODO: Transformable protocol?

public func * (lhs:BezierCurveChain, rhs:CGAffineTransform) -> BezierCurveChain {

    let transformedCurves = lhs.curves.map() {
        return $0 * rhs
    }
    return BezierCurveChain(curves: transformedCurves)
}
