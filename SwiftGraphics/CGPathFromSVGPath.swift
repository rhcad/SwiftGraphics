//
//  CGPathFromSVGPath.swift
//  SwiftGraphics
//
//  Created by Zhang Yungui on 2/11/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

/**
 Convenience function to create path from string like SVG path element.

 - parameter d: path string as the ‘d’ attribute of SVG path. It begins with a ‘M’ character and can contain
           instructions ‘MmLlCcQqSsTtZz’ as described in http://www.w3.org/TR/SVGTiny12/paths.html

 :test:   CGPathFromSVG("M20,50 Q40,5 100,50").endPoint
 :result: CGPoint((100,50))

 :return: the new path.
 */
public func CGPathFromSVGPath(d:String) -> CGMutablePath
{
    let path = CGPathCreateMutable()
    CGPathFromSVGPath(path, d)
    return path
}
