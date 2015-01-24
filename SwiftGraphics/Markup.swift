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
    func drawInContext(context:CGContext)
}

// TODO: Create "Markupable" protocol

public struct Guide: Markup {

    public let drawable:Drawable
    public let tag:String?

    public init(drawable:Drawable, tag:String? = nil) {
        self.drawable = drawable
        self.tag = tag
    }

    public func drawInContext(context:CGContext) {
        drawable.drawInContext(context)
    }
}

public struct Marker: Markup {
    public let point:CGPoint
    public let tag:String?

    public init(point:CGPoint, tag:String? = nil) {
        self.point = point
        self.tag = tag
    }

    public func drawInContext(context:CGContext) {
        context.strokeSaltire(CGRect(center:point, diameter:10))
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
