// Playground - noun: a place where people can play

import Cocoa
import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground
import SwiftUtilities

let context = CGContextRef.bitmapContext(CGSize(w:480, h:320), origin:CGPoint(x:0.0, y:0.0))
context.style

let bad_points = [
    CGPoint(x:101.15234375, y:243.140625),
    CGPoint(x:101.15234375, y:241.05859375),
    CGPoint(x:101.15234375, y:237.93359375),
    CGPoint(x:101.15234375, y:235.8515625),
]
let bad_hull = monotoneChain(bad_points)

let rng = SwiftUtilities.random

var points = arrayOfRandomPoints(50, range: CGRect(w:480, h:320), rng:rng)
points.count

//let hull = grahamScan(points)

for (index, point) in points.enumerate() {
    context.strokeCross(CGRect(center:point, radius:5))
    context.drawLabel("\(index)", point:point + CGPoint(x:2, y:0), size:10)
}

let hull = monotoneChain(points, sorted:false)
hull.count
context.strokeLine(hull, closed:true)

context.nsimage

