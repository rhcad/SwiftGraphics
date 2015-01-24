//
//  Scratch.swift
//  HandleEditor
//
//  Created by Jonathan Wight on 11/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import SwiftGraphics

// MARK: -

protocol Drawable {
    func draw(context:CGContext)
}

extension Rectangle : Drawable {
    func draw(context:CGContext) {
        context.strokeRect(self)
    }
}

extension Line : Drawable {
    func draw(context:CGContext) {
    }
}

extension LineSegment : Drawable {
    func draw(context:CGContext) {
        context.strokeLine(start, end)
    }
}
