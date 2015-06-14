//
//  Circle.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: Circle

public struct Circle {
    public let center:CGPoint
    public let radius:CGFloat
    public var diameter:CGFloat {
        return radius * 2
    }
    
    public init(center:CGPoint = CGPointZero, radius:CGFloat) {
        self.center = center
        self.radius = radius
    }
    
    public init(center:CGPoint = CGPointZero, diameter:CGFloat) {
        self.center = center
        self.radius = diameter * 0.5
    }
}

extension Circle: Geometry {
    public var frame: CGRect {
        return CGRect(center: center, diameter: diameter)
    }
}

extension Circle {

    // TODO: Just convert into an ellipse.
    var toBezierCurves:(BezierCurve, BezierCurve, BezierCurve, BezierCurve) {
        let quadrants = [
            CGSize(w:-1.0, h:-1.0),
            CGSize(w:1.0, h:-1.0),
            CGSize(w:-1.0, h:1.0),
            CGSize(w:1.0, h:1.0),
        ]

        let d = radius * 4.0 * (sqrt(2.0) - 1.0) / 3.0

        // Create a cubic bezier curve for the each quadrant of the circle...
        // Note this does not draw the curves either clockwise or anti-clockwise - and not suitable for use in a bezier path.
        var curves = quadrants.map() {
            (quadrant:CGSize) -> BezierCurve in
            return BezierCurve(
                start:self.center + CGPoint(x:self.radius) * quadrant,
                control1:self.center + (CGPoint(x:self.radius) + CGPoint(y:d)) * quadrant,
                control2:self.center + (CGPoint(y:self.radius) + CGPoint(x:d)) * quadrant,
                end:self.center + CGPoint(y:self.radius) * quadrant
            )
        }

    // TODO: Converting into an array and then a tuple is silly.
    return (curves[0], curves[1], curves[2], curves[3])
    }
}
