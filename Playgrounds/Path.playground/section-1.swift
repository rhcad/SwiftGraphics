// Playground - noun: a place where people can play

import Cocoa
import CoreGraphics
import SwiftGraphics

let context = CGContextRef.bitmapContext(CGSize(w:201, h:201))
context.setFillColor(CGColor.greenColor())
CGContextFillRect(context, CGRect(w:201, h:201))

var path = CGPathCreateMutable()

path.move(CGPoint(x:5, y:5))
path.addLine(CGPoint(x:100, y:0), relative:true)
path.addLine(CGPoint(x:0, y:100), relative:true)
path.addLine(CGPoint(x:-100, y:0), relative:true)
path.addCubicCurveToPoint(CGPoint(x:100, y:100), control1:CGPoint(x:50, y:0), control2:CGPoint(x:150, y:0))
path.close()

CGContextAddPath(context, path)
CGContextStrokePath(context)

path = CGPathFromSVGPath("M100,120h20t40,20Q150 200 100 140Z")
context.strokeColor = CGColor.blueColor()
CGContextAddPath(context, path)
CGContextStrokePath(context)

context.nsimage
