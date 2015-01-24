//
//  CGContext.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public extension CGContext {

    func setFillColor(color:CGColor) {
        CGContextSetFillColorWithColor(self, color)
    }
    func setStrokeColor(color:CGColor) {
        CGContextSetStrokeColorWithColor(self, color)
    }

    func setLineWidth(width:CGFloat) {
        CGContextSetLineWidth(self, width)
    }

    func setLineCap(lineCap:CGLineCap) {
        CGContextSetLineCap(self, lineCap)
    }

    func setLineJoin(lineJoin:CGLineJoin) {
        CGContextSetLineJoin(self, lineJoin)
    }

    func setMiterLimit(miterLimit:CGFloat) {
        CGContextSetMiterLimit(self, miterLimit)
    }

    func setLineDash(lengths:[CGFloat], phase:CGFloat = 0.0) {
        lengths.withUnsafeBufferPointer {
            (buffer:UnsafeBufferPointer<CGFloat>) -> Void in
            CGContextSetLineDash(self, phase, buffer.baseAddress, UInt(lengths.count))
        }
    }

    func setFlatness(flatness:CGFloat) {
        CGContextSetFlatness(self, flatness)
    }

    func setAlpha(alpha:CGFloat) {
        CGContextSetAlpha(self, alpha)
    }

    func setBlendMode(blendMode:CGBlendMode) {
        CGContextSetBlendMode(self, blendMode)
    }
}

// MARK: "with" helpers

public extension CGContext {

    func with(block:() -> Void) {
        CGContextSaveGState(self)
        block()
        CGContextRestoreGState(self)
    }

    func withColor(color:CGColor, block:() -> Void) {
        with {
            self.setStrokeColor(color)
            self.setFillColor(color)
            block()
        }
    }
}


