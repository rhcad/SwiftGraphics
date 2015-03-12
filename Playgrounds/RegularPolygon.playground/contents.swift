// Playground - noun: a place where people can play

import Cocoa
import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

let context = CGContextRef.bitmapContext(CGSize(w:320, h:320), origin:CGPoint(x:0.5, y:0.5))

let styleElements:[StyleElement] = [
    .strokeColor(CGColor.blackColor().withAlpha(0.5)),
]
var style = Style(elements:styleElements)

let start_color = HSV(h: 0.5, s: 1.0, v: 0.5)
let end_color = HSV(h: 1.0, s: 0.5, v: 1.0)

for var n:CGFloat = 0; n <= 1.0; n += 0.05 {
    let p = RegularPolygon(nside: 3, center: CGPoint.zeroPoint, radius: lerp(160, 0, n), startAngle: n * 2)

    let color = lerp(start_color, end_color, n)

    style.fillColor = color.cgColor.withAlpha(0.1)
    context.draw(p, style:style)
}

let p = RegularPolygon(nside: 3, center: CGPoint.zeroPoint, radius: 160)
p.circumcircle.drawInContext(context)


context.nsimage
