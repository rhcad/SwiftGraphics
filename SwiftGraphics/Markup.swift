//
//  Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

// TODO: extend Drawable
public protocol Markup {
    var tag:String? { get }
    var style:Style? { get }
    func drawInContext(context:CGContext)
}

// TODO: Create "Markupable" protocol

public struct Guide: Markup {

    public let drawable:Drawable
    public let tag:String?
    public let style:Style?

    public init(drawable:Drawable, tag:String? = nil, style:Style? = nil) {
        self.drawable = drawable
        self.tag = tag
        self.style = style
    }

    public func drawInContext(context:CGContext) {

        if let style = style {
            CGContextSaveGState(context)
            context.apply(style)
        }

        drawable.drawInContext(context)

        if let style = style {
            CGContextRestoreGState(context)
        }
    }
}

public struct Marker: Markup {
    public let point:CGPoint
    public let tag:String?
    public var style:Style?

    public init(point:CGPoint, tag:String? = nil, style:Style? = nil) {
        self.point = point
        self.tag = tag
        self.style = style
    }

    public func drawInContext(context:CGContext) {
        if let style = style {
            CGContextSaveGState(context)
            context.apply(style)
        }

        context.strokeSaltire(CGRect(center:point, diameter:10))

        if let style = style {
            CGContextRestoreGState(context)
        }
    }

    public static func markers(points:[CGPoint]) -> [Marker] {
        return points.map() {
            return Marker(point:$0)
        }
    }
}

public extension CGContext {
    func draw(markup:[Markup], styles:[String:Style]? = nil) {
        for item in markup {

            let style = styles?[item.tag!]

            if let style = style {
                CGContextSaveGState(self)
                apply(style)
            }

            item.drawInContext(self)

            if let style = style {
                CGContextRestoreGState(self)
            }
        }
    }
}
