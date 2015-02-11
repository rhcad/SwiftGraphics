//
//  Geometry.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/24/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public protocol Geometry {
    var frame:CGRect { get }
}

public protocol CGPathable {
    var cgpath:CGPath { get }
}

// TODO: Rename to Intersectionable? ICK
public protocol HitTestable {
    func contains(point:CGPoint) -> Bool
    func intersects(rect:CGRect) -> Bool
    func intersects(path:CGPath) -> Bool
}
