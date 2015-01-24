// Playground - noun: a place where people can play

import CoreGraphics
import SwiftGraphics
import SwiftGraphicsPlayground

var ellipses = [
    Ellipse(
        center:CGPointZero,
        semiMajorAxis:150.0,
        eccentricity:0.9,
        rotation:DegreesToRadians(45)
    ),
//    Ellipse(
//        center:CGPointZero,
//        semiMajorAxis:150.0,
//        semiMinorAxis:65.3834841531101,
//        rotation:DegreesToRadians(45)
//        ),
//    Ellipse(frame:CGRect(center:CGPointZero, size:CGSize(w:300, h:65.3834841531101 * 2))),
//    Ellipse(frame:CGRect(center:CGPointZero, size:CGSize(w:300, h:200))),
//    Ellipse(frame:CGRect(center:CGPointZero, size:CGSize(w:200, h:300))),
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



var generator = ellipses.generate()

let tileSize = CGSize(w:400, h:400)
let bitmapSize = tileSize * CGFloat(s)

let cgimage = CGContextRef.imageWithBlock(bitmapSize, color:CGColor.lightGrayColor(), origin:CGPointZero) {
    (context:CGContext) -> Void in

    tiled(context, tileSize, IntSize(width:s, height:s), origin:CGPoint(x:0.5, y:0.5)) {
        (context:CGContext) -> Void in

        if let ellipse = generator.next() {


            context.stroke(ellipse.asBezierChain)

            let markup = ellipse.markup
            context.draw(markup, styles:styles)
        }
    }
}

let image = NSImage(CGImage: cgimage, size: cgimage.size)  
