// Playground - noun: a place where people can play

import Cocoa
import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

func dump(t:Triangle) -> String {
    var s = ""
    s += "Points: \(t.points)\n"
    s += "Lengths: \(t.lengths)\n"
    s += "Angles: \(RadiansToDegrees(t.angles.0), RadiansToDegrees(t.angles.1), RadiansToDegrees(t.angles.2))\n"
    s += "isIsosceles: \(t.isIsosceles)\n"
    s += "isEquilateral: \(t.isEquilateral)\n"
    s += "isScalene: \(t.isScalene)\n"
    s += "isRightAngled: \(t.isRightAngled)\n"
    s += "isOblique: \(t.isOblique)\n"
    s += "isAcute: \(t.isAcute)\n"
    s += "isObtuse: \(t.isObtuse)\n"
    s += "isDegenerate: \(t.isDegenerate)\n"
    s += "signedArea: \(t.signedArea)\n"
    return s    
}

func pt(x:CGFloat, y:CGFloat) -> CGPoint {
    return CGPoint(x:x, y:y)
}

let context = CGContextRef.bitmapContext(CGSize(w:480, h:320), origin:CGPoint(x:0.5, y:0.5))

let t1 = Triangle(pt(100,0), pt(200,0), pt(100,150))


CGContextTranslateCTM(context, -t1.circumcenter.x, -t1.circumcenter.y)

context.draw(t1)
context.draw(t1.markup)

context.nsimage

