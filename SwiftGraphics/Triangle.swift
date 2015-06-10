//
//  Geometry+Triangle.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public struct Triangle {
    // TODO: Rename -> vertex
    public let points: (CGPoint, CGPoint, CGPoint)

    // TODO: Deprecate and take a tuple
    public init(_ p0:CGPoint, _ p1:CGPoint, _ p2:CGPoint) {
        self.points = (p0, p1, p2)
    }
}

public extension Triangle {
    /**
     Convenience initializer creating trangle from points in a rect.
     p0 is top middle, p1 and p2 are bottom left and bottom right
     */
    init(rect:CGRect, rotation:CGFloat = 0.0) {

        var p0 = rect.midXMinY
        var p1 = rect.minXMaxY
        var p2 = rect.maxXMaxY

        if rotation != 0.0 {
            let mid = rect.mid
            let transform = CGAffineTransform(rotation: rotation, origin:mid)
            p0 *= transform
            p1 *= transform
            p2 *= transform
        }

        self.points = (p0, p1, p2)
    }
}

public extension Triangle {

    init(points:[CGPoint]) {
        assert(points.count == 3)
        self.points = (points[0], points[1], points[2])
    }

    public var pointsArray:[CGPoint] {
        get {
            return [points.0, points.1, points.2]
        }
    }

}

public extension Triangle {

    public var lengths: (CGFloat, CGFloat, CGFloat) {
        get {
            return (
                (points.0 - points.1).magnitude,
                (points.1 - points.2).magnitude,
                (points.2 - points.0).magnitude
            )
        }
    }

    public var angles: (CGFloat, CGFloat, CGFloat) {
        get {
            let a1 = angle(points.0, points.1, points.2)
            let a2 = angle(points.1, points.2, points.0)
            let a3 = DegreesToRadians(180) - a1 - a2
            return (a1,a2,a3)
        }
    }
    
    public var isEquilateral: Bool {
        get {
            return equalities(self.lengths, test: { $0 ==% $1 }) == 3
        }
    }
    
    public var isIsosceles: Bool {
        get {
            return equalities(self.lengths, test: { $0 ==% $1 }) == 2
        }
    }
    
    public var isScalene: Bool {
        get {
            return equalities(self.lengths, test: { $0 ==% $1 }) == 1
        }
    }
    
    public var isRightAngled: Bool {
        get {
            let a = self.angles
            let rightAngle = CGFloat(0.5 * M_PI)
            return a.0 ==% rightAngle || a.1 ==% rightAngle || a.2 ==% rightAngle
        }
    }
    
    public var isOblique: Bool {
        get {
            return isRightAngled == false
        }
    }
    
    public var isAcute: Bool {
        get {
            let a = self.angles
            let rightAngle = CGFloat(0.5 * M_PI)
            return a.0 < rightAngle && a.1 < rightAngle && a.2 < rightAngle
        }
    }

    public var isObtuse: Bool {
        get {
            let a = self.angles
            let rightAngle = CGFloat(0.5 * M_PI)
            return a.0 > rightAngle || a.1 > rightAngle || a.2 > rightAngle
        }
    }

    public var isDegenerate: Bool {
        get {
            let a = self.angles
            let r180 = CGFloat(M_PI)
            return a.0 ==% r180 || a.1 ==% r180 || a.2 ==% r180
        }
    }

    public var signedArea: CGFloat {
        get {
            let (a, b, c) = points
//            let signedArea = 0.5 * (
//                a.x * (b.y - c.y) +
//                b.x * (c.y - a.y) +
//                c.x * (a.y - b.y)
//            )
//            return signedArea
            // TODO: Swift 1.2: Simplified for "expression was too complex to be solved in reasonable time; consider breaking up the expression into distinct sub-expressions"
            let signedArea = (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) * CGFloat(0.5)
            return signedArea
        }
    }
    
    public var area: CGFloat { get { return abs(signedArea) } }

    // https://en.wikipedia.org/wiki/Circumscribed_circle  
    public var circumcenter : CGPoint {
        get {
            let (a, b, c) = points
//            let D = 2 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
            // TODO: Swift 1.2: Simplified for "expression was too complex to be solved in reasonable time; consider breaking up the expression into distinct sub-expressions"
            let D = (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) * CGFloat(2.0)
            
            let a2 = a.x ** 2 + a.y ** 2
            let b2 = b.x ** 2 + b.y ** 2
            let c2 = c.x ** 2 + c.y ** 2
            
            let X = (a2 * (b.y - c.y) + b2 * (c.y - a.y) + c2 * (a.y - b.y)) / D
            let Y = (a2 * (c.x - b.x) + b2 * (a.x - c.x) + c2 * (b.x - a.x)) / D

            return CGPoint(x:X, y:Y)
        }
    }
    
    public var circumcircle : Circle {
        get {
            let (a,b,c) = lengths
            let diameter = (a * b * c) / (2 * area)
            return Circle(center:circumcenter, diameter:diameter)
        }
    }

    public var inradius : CGFloat {
        get {
            let (a, b, c) = lengths
            return 2 * area / (a + b + c)
        }
    }
}

// Cartesian coordinates
// TODO: Not quite working perfectly yet...
public extension Triangle {

    public var incenter : CGPoint {
        get {
            return toCartesian(alpha:1, beta:1, gamma:1)
        }
    }

    // converts trilinear coordinates to Cartesian coordinates relative
    // to the incenter; thus, the incenter has coordinates (0.0, 0.0)
    // TODO: THis seems broken!
    public func toLocalCartesian(alpha  alpha:CGFloat, beta:CGFloat, gamma:CGFloat) -> CGPoint {
        let area = self.area
        let (a,b,c) = lengths
        let r = 2 * area / (a + b + c)
        let k = 2 * area / (a * alpha + b * beta + c * gamma)
//        let C:CGFloat = DegreesToRadians(90)//angles.2
        let C = angles.2
        // (Unnecessarily specify CGFloat to prevent compiler from complaining about complexity while inferring type)
        let x:CGFloat = (k * beta - r + (k * alpha - r) * cos(C)) / sin(C)
        let y = k * alpha - r
        return CGPoint(x:x, y:y)
    }    

    // TODO: This seems broken!
    public func toCartesian(alpha  alpha:CGFloat, beta:CGFloat, gamma:CGFloat) -> CGPoint {
        let a = toLocalCartesian(alpha:alpha, beta:beta, gamma:gamma)
        let delta = toLocalCartesian(alpha:0,beta:0, gamma:1)
        return points.0 + a - delta
    }    
}

// MARK: Utilities

func equalities <T> (e:(T, T, T), test:((T, T) -> Bool)) -> Int {
    var c = 1
    if test(e.0, e.1) {
        c++
    }
    if test(e.1, e.2) {
        c++
    }
    if test(e.2, e.0) {
        c++
    }
    return min(c, 3)
}

extension Triangle: Geometry {
    public var frame:CGRect {
        get {
            // TODO faster to just do min/maxes
            return CGRect.unionOfPoints([points.0, points.1, points.2])
        }
    }
}
