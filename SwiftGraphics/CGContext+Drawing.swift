//
//  CGContext+Drawing.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/24/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

// TODO: This code is mostly experimental, use at your own risk - see TODO.markdown

 /**
  *  Most of this will be deprecated and replaced by the Drawable API.
  */

public extension CGContext {

    func strokePath(path:CGPath) {
        CGContextAddPath(self, path)
        CGContextStrokePath(self)
    }

    func fillRect(rect:CGRect) {
        CGContextFillRect(self, rect)
    }

    func strokeRect(rect:CGRect) {
        CGContextStrokeRect(self, rect)
    }

    func strokeEllipseInRect(rect:CGRect) {
        CGContextStrokeEllipseInRect(self, rect)
    }

    func strokeLines(points:[CGPoint]) {
        points.withUnsafeBufferPointer {
            (p:UnsafeBufferPointer<CGPoint>) -> Void in
            CGContextStrokeLineSegments(self, p.baseAddress, UInt(points.count))
        }
    }

    func strokeLine(p1:CGPoint, _ p2:CGPoint) {
        strokeLines([p1, p2])
    }

    // TODO: Rename strokePolygon?
    func strokeLine(points:[CGPoint], close:Bool = false) {
        var newPoints:[CGPoint] = []
        for (first, second) in GeneratorOf(SlidingWindow(points)) {
            if second == nil {
                if (close == true) {
                    newPoints.append(first)
                    newPoints.append(points[0])
                }
                break
            }
            newPoints.append(first)
            newPoints.append(second!)
        }

        strokeLines(newPoints)
    }

    
    func fillCircle(#center:CGPoint, radius:CGFloat) {
        let rect = CGRect(center:center, size:CGSize(width:radius * 2, height:radius * 2))
        CGContextFillEllipseInRect(self, rect)
    }
    
    func fillCircle(circle:Circle) {
        CGContextFillEllipseInRect(self, circle.frame)
    }

// MARK: Convenience shapes

    func strokeCross(rect:CGRect) {
        let linePoints = [
            CGPoint(x:rect.minX, y:rect.midY), CGPoint(x:rect.maxX, y:rect.midY),
            CGPoint(x:rect.midX, y:rect.minY), CGPoint(x:rect.midX, y:rect.maxY),
        ]
        strokeLines(linePoints)
    }

    func strokeSaltire(rect:CGRect) {    
        let linePoints = [
            CGPoint(x:rect.minX, y:rect.minY), CGPoint(x:rect.maxX, y:rect.maxY),
            CGPoint(x:rect.minX, y:rect.maxY), CGPoint(x:rect.maxX, y:rect.minY),
        ]
        strokeLines(linePoints)
    }


    // TODO: Rename/Deprecate
    func plotPoints(points:[CGPoint]) {
        for (index, point) in enumerate(points) {
            self.strokeCross(CGRect(center:point, diameter:10))
        }
    }
}
