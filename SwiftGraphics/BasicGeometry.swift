//
//  Geometry.swift
//  QuadTree
//
//  Created by Jonathan Wight on 8/6/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

import CoreGraphics

// MARK: Rectangle

// TODO: Why not just make a typealias for CGRect? #question #help-wanted
public struct Rectangle {
    public var origin:CGPoint
    public var size:CGSize

    public init(frame:CGRect) {
        origin = frame.origin
        size = frame.size
    }
}

extension Rectangle: Geometry {
    public var frame: CGRect {
        get {
            return CGRect(origin:origin, size:size)
        }
        set {
            origin = newValue.origin
            size = newValue.size
        }
    }
}

// TODO: This cannot live in other file due to swiftc problems.
extension Rectangle: Drawable {
   public func drawInContext(context:CGContext) {
        context.strokeRect(self.frame)
    }
}


// MARK: Saltire

public struct Saltire {
    public let frame:CGRect

    public init(frame:CGRect) {
        self.frame = frame
    }
}
