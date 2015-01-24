//
//  Geometry.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/24/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public protocol Geometry {
    var frame:CGRect { get }
}

// HitTestable and Pathable should be moved.

public protocol HitTestable {
    func contains(point:CGPoint) -> Bool
    func onEdge(point:CGPoint, lineThickness:CFloat) -> Bool
}

public protocol Pathable {
    var path:Path { get }
}
