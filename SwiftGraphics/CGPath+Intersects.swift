//
//  CGPath+Intersects.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/3/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics
import Accelerate

public extension CGPath {

    func intersects(drawing:CGContext -> Void) -> Bool {
        let boundingBox = CGPathGetBoundingBox(self)

        var context = CGContext.bitmapContext(boundingBox, color:CGColor.blackColor())
        CGContextSetAllowsAntialiasing(context, false)

#if arch(i386) || arch(arm)
        typealias WordType = UInt32
        let fill:WordType = 0x00FF00FF // Green
#elseif arch(x86_64) || arch(arm64)
        typealias WordType = UInt64
        let fill:WordType = 0x00FF00FF00FF00FF // Ultragreen.
#endif

        let data = UnsafePointer <WordType> (CGBitmapContextGetData(context))
        let length = Int(CGBitmapContextGetHeight(context) * CGBitmapContextGetBytesPerRow(context))
// TODO: Deal with leftover
//        assert(length % sizeof(WordType) == 0)
        let buffer = UnsafeBufferPointer <WordType> (start:data, count:length / sizeof(WordType))
        let clear = buffer[0]

        CGContextAddPath(context, self)
        CGContextClip(context)
        context.setFillColor(CGColor.redColor())
        CGContextFillRect(context, boundingBox)
        context.setFillColor(CGColor.greenColor())
        drawing(context)

        for word in buffer {
            if word == fill {
                return true
            }
        }

        return false
    }


    public func intersects(path:CGPath) -> Bool {

        let boundingBox = CGPathGetBoundingBox(self)

        if boundingBox.intersects(CGPathGetBoundingBox(path)) == false {
            return false
        }

        return intersects() { CGContextAddPath($0, path); CGContextFillPath($0) }
    }

    public func intersects(rect:CGRect) -> Bool {

        let boundingBox = CGPathGetBoundingBox(self)

        if boundingBox.intersects(rect) == false {
            return false
        }

        return intersects() { CGContextFillRect($0, rect) }
    }
}
