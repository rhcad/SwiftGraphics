// Playground - noun: a place where people can play

import SwiftGraphics
import SwiftGraphicsPlayground

let size = CGSize(w:240, h:240)
let context = CGContextRef.bitmapContext(size)
context.setFillColor(CGColor.lightGrayColor())
CGContextFillRect(context, CGRect(size:size))

CGContextTranslateCTM(context, 20, 20)

let curves = [
    BezierCurve(
        start: CGPoint(x:10,y:0),
        control1: CGPoint(x:-10,y:180),
        control2: CGPoint(x:150,y:200),
        end: CGPoint(x:200,y:0)),
//    BezierCurve(
//        start: CGPoint(x:40,y:10),
//        control1: CGPoint(x:140,y:100),
//        end: CGPoint(x:100,y:10)),
    ]

let styles = [
    "control":Style(elements:[
        .strokeColor(CGColor.redColor()),
    ]),
    "start":Style(elements:[
        .strokeColor(CGColor.redColor()),
    ]),
    "end":Style(elements:[
        .strokeColor(CGColor.redColor()),
    ]),
    "controlLine":Style(elements:[
        .strokeColor(CGColor.blueColor()),
        .lineDash([5,5]),
    ]),
    "boundingBox":Style(elements:[
        .strokeColor(CGColor.blueColor()),
        .lineDash([5,5]),
    ]),
    "simpleBounds":Style(elements:[
        .strokeColor(CGColor.blueColor()),
        .lineDash([5,5]),
    ]),
]

for curve in curves {
    let markup = curve.markup
    context.draw(markup, styles:styles)

    context.stroke(curve)
}


context.nsimage

