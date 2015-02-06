//
//  RegularPolygon.swift
//  SwiftGraphics
//
//  Created by Zhang Yungui on on 15/1/23.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: Regular Polygon

public struct RegularPolygon {
    public let nside:Int
    public let center:CGPoint
    public let vertex:CGPoint
    public var radius:CGFloat { get { return center.distanceTo(vertex) } }
    public var startAngle:CGFloat { get { return (vertex - center).direction } }
    
    public init(nside:Int, center:CGPoint, vertex:CGPoint) {
        self.nside = nside
        self.center = center
        self.vertex = vertex
    }
    
    public init(nside:Int, center:CGPoint, radius:CGFloat) {
        self.init(nside:nside, center:center, vertex: center + CGPoint(x:radius))
    }
    
    public init(nside:Int, center:CGPoint, radius:CGFloat, startAngle:CGFloat) {
        self.init(nside:nside, center:center, vertex: center.polarPoint(startAngle, radius:radius))
    }
}

public extension RegularPolygon {
    public var isDegenerate: Bool { get { return nside < 3 || center ==% vertex } }
    
    public var centralAngle:CGFloat { get { return CGFloat(2 * M_PI / Double(nside)) } }
    public var interiorAngle:CGFloat { get { return CGFloat(Double(nside - 2) * M_PI / Double(nside)) } }
    public var exteriorAngle:CGFloat { get { return centralAngle } }
    
    public var area: CGFloat { get { return CGFloat(radius ** 2 * sin(centralAngle) * CGFloat(nside) / 2) } }
    public var length:CGFloat { get { return sideLength * CGFloat(nside) } }
    public var sideLength:CGFloat { get { return CGFloat(2 * radius * sin(centralAngle / 2)) } }
    
    public var inradius:CGFloat { get { return radius * cos(centralAngle / 2) } }
    public var circumRadius:CGFloat { get { return radius } }
    
    public var circumcircle: Circle { get { return Circle(center:center, radius:radius) } }
    public var incircle: Circle { get { return Circle(center:center, radius:inradius) } }
    
    public var points:[CGPoint] { get {
        let s = startAngle, c = centralAngle, r = radius
        return (0..<nside).map { self.center.polarPoint(s + c * CGFloat($0), radius:r) }
    }}
    
    public func getPoint(index:Int) -> CGPoint {
        return center.polarPoint(startAngle + centralAngle * CGFloat(index), radius:radius)
    }
}

// MARK: Applying transform

public func * (lhs:RegularPolygon, rhs:CGAffineTransform) -> RegularPolygon {
    return RegularPolygon(nside:lhs.nside, center:lhs.center * rhs, vertex:lhs.vertex * rhs)
}

// MARK: Convenience initializers

public extension RegularPolygon {
    
    //! Construct with center and two adjacent vertexes.
    // The adjacent vertex is approximately on the ray from center to the first vertex.
    public init(center:CGPoint, vertex:CGPoint, adjacent:CGPoint) {
        let angle = (adjacent - center).angleTo(vertex - center)
        let nside = (angle == 0) ? 3 : max(3, Int(round(CGFloat(M_PI) / angle)))
        self.init(nside:nside, center:center, vertex:vertex)
    }
    
}

// MARK: Move vertexes

public extension RegularPolygon {
    
    //! Returns new polygon whose vertex moved to the specified location.
    public func pointMoved(v:(Int, CGPoint)) -> RegularPolygon {
        if v.0 >= 0 && v.0 < nside {
            let angle = (v.1 - center).direction - centralAngle * CGFloat(v.0)
            return RegularPolygon(nside:nside, center:center, radius:radius, startAngle:angle)
        }
        return self * CGAffineTransform(translation:v.1 - center)
    }

    //! Returns new polygon whose two adjacent vertexes moved to the specified locations.
    public func twoPointsMoved(v1:(Int, CGPoint), _ v2:(Int, CGPoint)) -> RegularPolygon {
        func isBeside(i1:Int, i2:Int) -> Bool {
            return i1 >= 0 && i1 < i2 && i2 < nside && (i1 == i2 - 1 || (i1 == 0 && i2 == nside - 1))
        }
        if isBeside(min(v1.0, v2.0), max(v1.0, v2.0)) && v1.1 !=% v2.1 {
            let xf = CGAffineTransform(from1:getPoint(v1.0), from2:getPoint(v2.0), to1:v1.1, to2:v2.1)
            return self * xf
        }
        return self
    }
}
