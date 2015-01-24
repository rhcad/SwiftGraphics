//
//  Drawable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

// #############################################################################

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

    func draw <T> (things:Array <T>, style:Style? = nil, filter:T -> Drawable) {
        let drawables = things.map(filter)
        draw(drawables, style:style)
    }

}


//extension Array {
//    func converted <U> () -> [U] {
//        return self.map() {
//            (value:T) -> U in
//            return value as U
//        }
//    }
//}


// #############################################################################

public extension CGContext {

    // TODO: Rename.
    func plotPoints(points:[CGPoint]) {
        for (index, point) in enumerate(points) {
            self.strokeCross(CGRect(center:point, diameter:10))
        }
    }
}
