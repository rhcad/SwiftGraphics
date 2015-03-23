// Playground - noun: a place where people can play

import CoreGraphics
import SwiftUtilities
import SwiftGraphics
import SwiftGraphicsPlayground

var ellipses = [
    Ellipse(
        center:CGPointZero,
        semiMajorAxis:300.0,
        eccentricity:0.9,
        rotation:DegreesToRadians(45)
    ),
    Ellipse(
        center:CGPointZero,
        semiMajorAxis:300.0,
        semiMinorAxis:65.3834841531101 * 2,
        rotation:DegreesToRadians(0)
        ),
    Ellipse(frame:CGRect(center:CGPointZero, size:CGSize(w:600, h:65.3834841531101 * 4))),
    Ellipse(frame:CGRect(center:CGPointZero, size:CGSize(w:400, h:400))),
]

let s = Int(ceil(sqrt(Double(ellipses.count))))

let style1 = SwiftGraphics.Style(elements:[
    .strokeColor(CGColor.redColor()),
    ])
let style2 = SwiftGraphics.Style(elements:[
    .strokeColor(CGColor.blueColor()),
    .lineDash([5,5]),
    ])
let style3 = SwiftGraphics.Style(elements:[
    .strokeColor(CGColor.purpleColor()),
    .lineDash([2,2]),
    ])

let styles = [
    "center": style1,
    "foci": style1,
    "corner": style1,
    "-a": style3,
    "+a": style3,
    "-b": style3,
    "+b": style3,
    "A": style3,
    "B": style3,
    "frame": style2,
    "boundingBox": style2,
    ]


let cgpath = CGPathCreateWithEllipseInRect(CGRect(center:CGPointZero, radius:1.0), nil)
cgpath.dump()



var generator = ellipses.generate()

let tileSize = CGSize(width:800, height:800)
let bitmapSize = tileSize * CGFloat(s)

let cgimage = CGContextRef.imageWithBlock(bitmapSize, color:CGColor.lightGrayColor(), origin:CGPointZero) {
    (context:CGContext) -> Void in

    CGContextSetShouldAntialias(context, false)

    tiled(context, tileSize: tileSize, dimension: IntSize(width:s, height:s), origin:CGPoint(x:0.5, y:0.5)) {
        (context:CGContext) -> Void in

        if let ellipse = generator.next() {

            var c:CGFloat = 0.551915024494

            context.strokeColor = CGColor.greenColor()

            var curves = ellipse.toBezierCurves(c)
            context.stroke(curves.0)
            context.stroke(curves.1)
            context.stroke(curves.2)
            context.stroke(curves.3)

            context.strokeColor = CGColor.redColor()

            c = 4.0 * (sqrt(2.0) - 1.0) / 3.0 // 0.5522847498307936
            curves = ellipse.toBezierCurves(c)
            context.stroke(curves.0)
            context.stroke(curves.1)
            context.stroke(curves.2)
            context.stroke(curves.3)

            let markup = ellipse.markup
            context.draw(markup, styles:styles)
        }
    }
}

let image = NSImage(CGImage: cgimage, size: cgimage.size)
