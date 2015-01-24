//
//  Drawable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

public protocol Drawable: Geometry {
    func drawInContext(context:CGContextRef)
}

// MARK: CGContext+Drawable

public extension CGContext {
    func draw(drawable:Drawable, style:Style? = nil) {

        // TODO: Saving and restoring the graphics state each draw() seems very expensive. #performance #optimisation
        if let style = style {
            with(style) {
                drawable.drawInContext(self)
            }
        }
        else {
            with {
                drawable.drawInContext(self)
            }
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

}


