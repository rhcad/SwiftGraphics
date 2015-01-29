//
//  Gradient.swift
//  SwiftGraphics
//
//  Created by Zhang Yungui on 15/1/29.
//  Tested in the ShapeAnimation project: https://github.com/rhcad/ShapeAnimation-Swift/
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public struct Gradient {
    public var axial = false
    public var colors:[CGColor]? { didSet { cached = nil }}
    public var locations:[CGFloat]? { didSet { cached = nil }}
    public var orientation:(CGPoint, CGPoint)?
    
    public init() {}
    public init(colors:[CGColor], axial:Bool = false) {
        self.axial = axial
        self.colors = colors
    }
    public init(colors:[(CGFloat,CGFloat,CGFloat,CGFloat)], axial:Bool = false) {
        self.axial = axial
        setColors(colors)
    }
    public init(colors:[(CGFloat,CGFloat,CGFloat)], axial:Bool = false) {
        self.axial = axial
        setColors(colors)
    }
    mutating public func setColors(colors:[(CGFloat,CGFloat,CGFloat,CGFloat)]) {
        self.colors = colors.map{ CGColor.color(red:$0.0, green:$0.1, blue:$0.2, alpha:$0.3) }
    }
    mutating public func setColors(colors:[(CGFloat,CGFloat,CGFloat)]) {
        self.colors = colors.map{ CGColor.color(red:$0.0, green:$0.1, blue:$0.2) }
    }
    
    private var cached:CGGradient?
    mutating public func getGradient() -> CGGradient? {
        if let colors = colors {
            if let cg = cached {
                return cg
            }
            
            let colorspace = CGColorSpaceCreateDeviceRGB()
            var components:[CGFloat] = []
            var valid = false
            
            for c in colors {
                if c.alpha < 0.01 {
                    components += [0, 0, 0, 0]
                } else {
                    let n = Int(CGColorGetNumberOfComponents(c))
                    let a = CGColorGetComponents(c)
                    
                    if n == 2 { // CGColorSpaceCreateDeviceGray
                        for i in 0..<3 {
                            components.append(a[0])
                        }
                        components.append(a[1])
                    }
                    else if (n == 4) {
                        for i in 0..<4 {
                            components.append(a[i])
                        }
                    }
                    valid = true
                }
            }
            if valid {
                if let locations = locations {
                    cached = CGGradientCreateWithColorComponents(colorspace, components, locations, UInt(colors.count))
                } else {
                    cached = CGGradientCreateWithColorComponents(colorspace, components,
                        UnsafePointer<CGFloat>.null(), UInt(colors.count))
                }
                return cached
            }
        }
        return nil
    }
}

public extension CGContext {
    
    public func fill(style:Gradient?) -> Bool {
        let frame = CGContextGetClipBoundingBox(self)
        if style != nil && !frame.isEmpty {
            var style = style!
            if let cgGradient = style.getGradient() {
                let p1 = frame.origin + style.orientation!.0 * frame.size
                let p2 = frame.origin + style.orientation!.1 * frame.size
                if style.axial {
                    CGContextDrawRadialGradient(self, cgGradient,
                        frame.mid, 0, frame.mid, max(frame.width, frame.height), 0)
                } else {
                    CGContextDrawLinearGradient(self, cgGradient, p1, p2, 0)
                }
                return true
            }
        }
        return false
    }
    
    public func fillPath(style:Gradient?, path:CGPath?) -> Bool {
        var ret = false
        if style != nil && path != nil && path!.isClosed {
            CGContextSaveGState(self)
            CGContextAddPath(self, path!)
            CGContextClip(self)
            ret = fill(style)
            CGContextRestoreGState(self)
        }
        return ret
    }
    
    public func fillEllipseInRect(style:Gradient?, rect:CGRect) -> Bool {
        var ret = false
        if style != nil {
            CGContextSaveGState(self)
            CGContextAddEllipseInRect(self, rect)
            CGContextClip(self)
            ret = fill(style)
            CGContextRestoreGState(self)
        }
        return ret
    }
}
