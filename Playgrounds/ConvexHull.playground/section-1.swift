// Playground - noun: a place where people can play

import Cocoa
import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

let context = CGContextRef.bitmapContext(CGSize(w:480, h:320), origin:CGPoint(x:0.0, y:0.0))
context.style

var points = arrayOfRandomPoints(50, CGRect(w:480, h:320))

//let hull = grahamScan(points)

for (index, point) in enumerate(points) {
    context.strokeCross(CGRect(center:point, radius:5))
    context.drawLabel("\(index)", point:point + CGPoint(x:2, y:0), size:10)
}

let hull = monotoneChain(points, presorted:false)
context.strokeLine(hull, closed:true)

context.nsimage
