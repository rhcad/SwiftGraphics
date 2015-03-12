// Playground - noun: a place where people can play

import Cocoa
import CoreGraphics
import SwiftGraphics

let size = CGSize(w:100, h:100)
let context = CGContextRef.bitmapContext(size)
context.setFillColor(CGColor.lightGrayColor())
CGContextFillRect(context, CGRect(size:size))

let p1 = CGPoint(x:10, y:10), p2 = CGPoint(x:90, y:20)
context.strokeLine(p1, p2)

let p3 = p2.rulerPoint(p1, dx:0, dy:-40)
context.strokeLine(p2, p3)

let p4 = p3.rulerPoint(p1, dx:40)
context.strokeLine(p3, p4)

let p5 = p4.rulerPoint(p3, dx:0, dy:40)
context.strokeLine(p4, p5)

let p6 = p4.rulerPoint(p5, dx:20, dy:20)
context.strokeLine(p5, p6)

context.nsimage
