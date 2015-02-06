//
//  CoordinateSystems.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/2/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public enum GraphicsOrigin {
    case TopLeft
    case BottomLeft
    case Native

    var resolved: GraphicsOrigin {
        get {
            switch self {
                case .TopLeft, .BottomLeft:
                    return self
                case .Native:
                    #if os(OSX)
                    return .TopLeft
                    #else
                    return .BottomLeft
                    #endif
            }
        }
    }

    var isNative: Bool {
        get {
            switch self {
                case .TopLeft:
                    #if os(OSX)
                    return false
                    #else
                    return true
                    #endif
                case .BottomLeft:
                    #if os(OSX)
                    return true
                    #else
                    return false
                    #endif
                case .Native:
                    return true
            }
        }
    }
}

public extension CGPoint {
    func flipped(origin:GraphicsOrigin, insideRect:CGRect) -> CGPoint {
        if origin.isNative {
            return self
        }
        else {
            return self * CGAffineTransform(tx:0, ty:insideRect.size.height).scaled(sx:1, sy:-1)
        }
    }
}

public extension CGRect {
    func flipped(origin:GraphicsOrigin, insideRect:CGRect) -> CGRect {
        if origin.isNative {
            return self
        }
        else {
            return self * CGAffineTransform(tx:0, ty:insideRect.size.height).scaled(sx:1, sy:-1)
        }
    }
}