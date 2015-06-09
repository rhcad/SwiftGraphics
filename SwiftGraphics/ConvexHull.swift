//
//  ConvexHull.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public func convexHull(points:[CGPoint], sorted:Bool = false) -> [CGPoint] {
    return monotoneChain(points, sorted:sorted)
}
