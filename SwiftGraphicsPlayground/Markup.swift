//
//  Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics
import SwiftGraphics
import SwiftGraphicsPlayground

public protocol Markup {
    var tag:String? { get }
    var style:Style? { get }
    func draw(context:CGContext)
}

public struct Guide: Markup {

    public enum Type {
//        case line(Line)
        case lineSegment(LineSegment)
        case polygon(SwiftGraphics.Polygon)
        case rectangle(SwiftGraphics.Rectangle)
    }

    public let type:Type
    public let tag:String?
    public let style:Style?

    public init(type:Type, tag:String? = nil, style:Style? = nil) {
        self.type = type
        self.tag = tag
        self.style = style
    }

    public func draw(context:CGContext) {

        if let style = style {
            CGContextSaveGState(context)
            context.apply(style)
        }

        switch type {
//            case .line:
//                break
            case .lineSegment(let lineSegment):
                context.stroke(lineSegment)
            case .polygon(let polygon):
                context.stroke(polygon)
            case .rectangle(let rectangle):
                context.strokeRect(rectangle.frame)
        }

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

    public func draw(context:CGContext) {
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

            item.draw(self)

            if let style = style {
                CGContextRestoreGState(self)
            }
        }
    }
}
