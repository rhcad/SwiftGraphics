// Playground - noun: a place where people can play

import Foundation
import SwiftGraphics
import SwiftGraphicsPlayground

let points = [
    CGPoint(x:120,y:160),
    CGPoint(x:35,y:200),
    CGPoint(x:220,y:260),
    CGPoint(x:220,y:40),
]

let curve = BezierCurve(points:points)
let (leftCurve, rightCurve) = curve.split(0.85)


func matrix_form(points:[CGPoint], t:CGFloat) -> CGPoint {
    let values = [1, t, t ** 2, t ** 3]

    let m1 = Matrix(values:values, width:4, height:1)
    let m2 = Matrix <CGFloat> (values:[1,0,0,0, -3,3,0,0, 3,-6,3,0, -1,3,-3,1], width:4, height:4)

    let m3x_values:Array <CGFloat> = points.map() { return $0.x }
    let m3x = Matrix(values:m3x_values, width:1, height:m3x_values.count)

    let m3y_values:Array <CGFloat> = points.map() { return $0.y }
    let m3y = Matrix(values:m3y_values, width:1, height:m3y_values.count)

    var rx = m1 * m2 * m3x
    var ry = m1 * m2 * m3y

    return CGPoint(x:CGFloat(rx.values[0]), y:CGFloat(ry.values[0]))
}

matrix_form(points, 0.85)
curve.pointAlongCurve(0.85)



let cgimage = CGContextRef.imageWithBlock(CGSize(w:250, h:250), color:CGColor.lightGrayColor(), origin:CGPointZero) {
    (context:CGContext) -> Void in

    // Draw the whole bezier curve in green
    context.strokeColor = CGColor.greenColor().withAlpha(0.25)
    context.lineWidth = 8.0
    context.stroke(curve)
    context.lineWidth = 2.0

    // Draw the "left" portion of the curve in blue
    context.strokeColor = CGColor.blueColor()
    context.stroke(leftCurve)

    // Draw the "right" portion of the curve in red
    context.strokeColor = CGColor.redColor()
    context.stroke(rightCurve)

    // Get points along the curve and plot them
    context.lineWidth = 1.0
    var newPoints:[CGPoint] = []
    for var N:CGFloat = 0; N <= 1; N += 0.1 {
        newPoints.append(curve.pointAlongCurve(N))
    }
    context.strokeColor = CGColor.blackColor()
    context.plotPoints(newPoints)
}

let image = NSImage(CGImage: cgimage, size: cgimage.size)  
image
