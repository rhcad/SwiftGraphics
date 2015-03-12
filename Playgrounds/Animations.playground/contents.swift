// Playground - noun: a place where people can play

import Cocoa

import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

// See: http://zulko.github.io/blog/2014/09/20/vector-animations-with-python/

var c = Circle(center:CGPoint(x:156, y:200), radius:20)

let view = SGPRender("Test", XCPShowView) {
    (ctx:CGContext, bounds:CGRect) in
    ctx.draw(c)
}

view.tickBlock = {
    (time, timeInterval, fps) in

    let radius = 128 * (1.0 + (2.0 - fmod(time, 2.0)) ** 2.0) / 6.0
    c = Circle(center:CGPoint(x:156, y:200), radius:CGFloat(radius))
}
