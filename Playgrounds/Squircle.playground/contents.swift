// Playground - noun: a place where people can play

import Cocoa

import SwiftGraphics
import SwiftGraphicsPlayground

let context = CGContextRef.bitmapContext(CGSize(w:1200, h:1200), origin:CGPoint(x:0.5, y:0.5))

var size:CGFloat = 1024

var cornerRadius = round(size * (34.0 / 152.0) * 2.0) / 2.0

var f1:CGFloat = 1.528665
var f2:CGFloat = 1.088492963
var f3:CGFloat = 0.868406926
var f4:CGFloat = 0.631493778
var f5:CGFloat = 0.07491137
var f6:CGFloat = 0.372823815
var f7:CGFloat = 0.169059556

f1 = 1.512996779;
f2 = 1.000822998;
f3 = 0.857108385;
f4 = 0.636612366;
f5 = 0.074140812;
f6 = 0.375930619;
f7 = 0.169408557;


//var m =     CGPoint(x:cornerRadius * f1, y:0.0)
var l1 =    CGPoint(x:cornerRadius * f1, y:0.0)
var c1cp1 = CGPoint(x:cornerRadius * f2, y:0.0)
var c1cp2 = CGPoint(x:cornerRadius * f3, y:0.0)
var c1 =    CGPoint(x:cornerRadius * f4, y:cornerRadius * f5)
var c2cp1 = CGPoint(x:cornerRadius * f6, y:cornerRadius * f7)
var c2cp2 = CGPoint(x:cornerRadius * f7, y:cornerRadius * f6)
var c2 =    CGPoint(x:cornerRadius * f5, y:cornerRadius * f4)
var c3cp1 = CGPoint(x:0.0,               y:cornerRadius * f3)
var c3cp2 = CGPoint(x:0.0,               y:cornerRadius * f2)
var c3 =    CGPoint(x:0.0,               y:cornerRadius * f1)

//let points = [m, l1, c1cp1, c1cp2, l2, c2cp1, c2cp2, c2, c3cp1, c3cp2, c3]
//context.plotPoints(points)

//let curve1 = BezierCurve(start:m, controls:[c1cp1, c1cp2], end:l1)
//context.draw(curve1)

var chain = BezierCurveChain(curves: [
    BezierCurve(start:l1, controls:[c1cp1, c1cp2], end:c1),
    BezierCurve(controls:[c2cp1, c2cp2], end:c2),
    BezierCurve(controls:[c3cp1, c3cp2], end:c3)
])

chain = chain * CGAffineTransform(tx: -512, ty: -512)
context.draw(chain)


//chain = chain * CGAffineTransform(rotation: DegreesToRadians(90))
//context.draw(chain)
//
//chain = chain * CGAffineTransform(rotation: DegreesToRadians(90))
//context.draw(chain)
//
//chain = chain * CGAffineTransform(rotation: DegreesToRadians(90))
//context.draw(chain)


extension BezierCurve {

    public func asSwift() -> String {
        var lines:[String] = []

        if let start = start {
            lines.append("CGContextMoveToPoint(\(start.x), \(start.y))")
        }

        switch self.order {
            case .Quadratic:
                lines.append("CGContextAddQuadCurveToPoint(self, \(controls[0].x), \(controls[0].y), \(end.x), \(end.y))")
            case .Cubic:
                lines.append("CGContextAddCurveToPoint(self, \(controls[0].x), \(controls[0].y), \(controls[1].x), \(controls[1].y), \(end.x), \(end.y))")
            case .OrderN(let order):
                assert(false)
        }

        return "\n".join(lines)
    }
}

var lines:[String] = []
for curve in chain.curves {
    lines.append(curve.asSwift())
}

"\n".join(lines)

context.nsimage



