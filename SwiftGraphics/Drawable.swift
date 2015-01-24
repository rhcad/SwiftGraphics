//
//  Drawable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

public protocol HitTestable {
    func contains(point:CGPoint) -> Bool
    func onEdge(point:CGPoint, lineThickness:CFloat) -> Bool
}

public protocol Pathable {
    var path:Path { get }
}

public protocol Drawable {
    func drawInContext(context:CGContextRef)
}

// MARK: CGContext+Drawable

public extension CGContext {
    func draw(drawable:Drawable, style:Style? = nil) {
        if let style = style {
            with(style) {
                drawable.drawInContext(self)
            }
        }
        else {
            drawable.drawInContext(self)
        }
    }

    func draw(drawables:Array <Drawable>, style:Style? = nil) {
        let block:Void -> Void = {
            for drawable in drawables {
                self.draw(drawable)
            }
        }
        if let style = style {
            with(style, block)
        }
        else {
            block()
        }

    }

    /**
     This is a bit of a hack.

     :param: things <#things description#>
     :param: style  <#style description#>
     :param: filter <#filter description#>
     */
    func draw <T> (things:Array <T>, style:Style? = nil, filter:T -> Drawable) {
        let drawables = things.map(filter)
        draw(drawables, style:style)
    }

}
