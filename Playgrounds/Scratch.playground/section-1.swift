// Playground - noun: a place where people can play

import Cocoa

import SwiftGraphics
import SwiftGraphicsPlayground

let context = CGContextRef.bitmapContext(CGSize(w:480, h:320), origin:CGPoint(x:0.5, y:0.5))

context.fillCircle(center: CGPointZero, radius: 2)


let parameters = SVGArcParameters(x0: 0, y0: 0, rx: 100, ry: 0, angle: 0, largeArcFlag: false, sweepFlag: false, x: 200, y: 200)

let arc = Arc.arcWithSVGDefinition(parameters)




context.nsimage



