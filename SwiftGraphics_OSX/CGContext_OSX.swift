//
//  CGContext_OSX.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics
import AppKit

// MARK: Strings

public extension CGContext {
    func draw(string:String, point:CGPoint, attributes:NSDictionary?) {
        string._bridgeToObjectiveC().drawAtPoint(point, withAttributes:attributes as! [NSObject : AnyObject])
    }

    func drawLabel(string:String, point:CGPoint, size:CGFloat) {
        let attributes = [NSFontAttributeName:NSFont.labelFontOfSize(size)]
        draw(string, point:point, attributes:attributes)
    }
}
