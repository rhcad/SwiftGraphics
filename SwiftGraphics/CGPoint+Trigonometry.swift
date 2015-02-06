//
//  CGPoint+Trigonometry.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/5/15.
//  Contibutions by Zhang Yungui <https://github.com/rhcad> on 15/1/14.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public func dotProduct(lhs:CGPoint, rhs:CGPoint) -> CGFloat {
    return lhs.x * rhs.x + lhs.y * rhs.y
}

public func crossProduct(lhs:CGPoint, rhs:CGPoint) -> CGFloat {
    return lhs.x * rhs.y - lhs.y * rhs.x
}

public extension CGPoint {

    init(magnitude:CGFloat, direction:CGFloat) {
        x = cos(direction) * magnitude
        y = sin(direction) * magnitude
    }

    var magnitude: CGFloat {
        get {
            return sqrt(x * x + y * y)
        }
        set(v) {
            self = CGPoint(magnitude:v, direction:direction)
        }
    }

    var magnitudeSquared: CGFloat {
        get {
            return x * x + y * y
        }
    }

    var direction: CGFloat {
        get {
            return atan2(self)
        }
        set(v) {
            self = CGPoint(magnitude:magnitude, direction:v)
        }
    }

    var normalized: CGPoint {
        get {
            let len = magnitude
            return len ==% 0 ? self : CGPoint(x:x / len, y:y / len)
        }
    }

    var orthogonal: CGPoint {
        get {
            return CGPoint(x:-y, y:x)
        }
    }

    var transposed: CGPoint {
        get {
            return CGPoint(x:y, y:x)
        }
    }

}

public func atan2(point:CGPoint) -> CGFloat {   // (-M_PI, M_PI]
    return atan2(point.y, point.x)
}

// MARK: Distance and angle between two points or vectors

public extension CGPoint {

    func distanceTo(point: CGPoint) -> CGFloat {
        return (self - point).magnitude
    }
    
    func distanceTo(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return distanceToBeeline(p1, p2:p2).0
    }

    // TODO: What is a beeline????
    func distanceToBeeline(p1:CGPoint, p2:CGPoint) -> (CGFloat, CGPoint) {
        if p1 == p2 {
            return (distanceTo(p1), p1)
        }
        if p1.x == p2.x {
            return (abs(p1.x - self.x), CGPoint(x:p1.x, y:self.y))
        }
        if p1.y == p2.y {
            return (abs(p1.y - self.y), CGPoint(x:self.x, y:p1.y))
        }
        
        let t1 = (p2.y - p1.y) / (p2.x - p1.x)
        let t2 = -1 / t1
        let numerator = self.y - p1.y + p1.x * t1 - self.x * t2
        let perpx = numerator / (t1 - t2)
        let perp = CGPoint(x: perpx, y: p1.y + (perpx - p1.x) * t1)
        
        return (distanceTo(perp), perp)
    }

    func angleTo(vec:CGPoint) -> CGFloat {       // [-M_PI, M_PI)
        return atan2(crossProduct(self, vec), dotProduct(self, vec))
    }
}

/**
 Return true if a, b, and c all lie on the same line.
 */
public func collinear(a:CGPoint, b:CGPoint, c:CGPoint) -> Bool {
    return (b.x - a.x) * (c.y - a.y) ==% (c.x - a.x) * (b.y - a.y)
}

/**
 Return true if c is near to the beeline a b.
 */
public func collinear(a:CGPoint, b:CGPoint, c:CGPoint, tolerance:CGFloat) -> Bool {
    return c.distanceTo(a, p2:b) <= tolerance
}

/**
 Return the angle between vertex-p1 and vertex-vertex.
 */
public func angle(vertex:CGPoint, p1:CGPoint, p2:CGPoint) -> CGFloat {
    return abs((p1 - vertex).angleTo(p2 - vertex))
}

// MARK: Relative point calculation methods like ruler tools

public extension CGPoint {
    
    /**
     Calculate a point with polar angle and radius based on this point.
     
     :param: angle polar angle in radians.
     :param: radius the length of the polar radius
     
     :returns: the point relative to this point.
     */
    func polarPoint(angle:CGFloat, radius:CGFloat) -> CGPoint {
        return CGPoint(x: x + radius * cos(angle), y: y + radius * sin(angle));
    }
    
    /**
     Calculate a point along the direction from this point to 'dir' point.
     
     :param: dir the direction point.
     :param: dx the distance from this point to the result point.
               The negative value represents along the opposite direction.
     
     :returns: the point relative to this point.
     */
    func rulerPoint(dir:CGPoint, dx:CGFloat) -> CGPoint {
        let len = distanceTo(dir)
        if len == 0 {
            return CGPoint(x:x + dx, y:y)
        }
        let d = dx / len
        return CGPoint(x:x + (dir.x - x) * d, y:y + (dir.y - y) * d)
    }
    
    /**
     Calculate a point along the direction from this point to 'dir' point.
     dx and dy may be negative which represents along the opposite direction.
     
     :param: dir the direction point.
     :param: dx the projection distance along the direction from this point to 'dir' point.
     :param: dy the perpendicular distance from the result point to the line of this point to 'dir' point.
     
     :returns: the point relative to this point.
     */
    func rulerPoint(dir:CGPoint, dx:CGFloat, dy:CGFloat) -> CGPoint {
        let len = distanceTo(dir)
        if len == 0 {
            return CGPoint(x:x + dx, y:y + dy)
        }
        let dcos = (dir.x - x) / len
        let dsin = (dir.y - y) / len
        return CGPoint(x:x + dx * dcos - dy * dsin, y:y + dx * dsin + dy * dcos)
    }
}

// MARK: Vector projection

public extension CGPoint {
    
    public static var vectorTolerance:CGFloat = 1e-4
    
    //! Returns whether this vector is perpendicular to another vector.
    func isPerpendicularTo(vec:CGPoint) -> Bool {
        let sinfz = abs(crossProduct(self, vec))
        if sinfz == 0 {
            return false
        }
        let cosfz = abs(dotProduct(self, vec))
        return cosfz <= sinfz * CGPoint.vectorTolerance
    }

    /**
     Returns the length of the vector which perpendicular to the projection of this vector onto xAxis vector.
     
     :param:   xAxis projection target vector.
     :returns: perpendicular distance which is positive if this vector is in the CCW direction of xAxis and negative if clockwise.
     */
    func distanceToVector(xAxis:CGPoint) -> CGFloat {
        let len = xAxis.magnitude
        return len == 0 ? magnitude : crossProduct(xAxis, self) / len
    }
    
    //! Returns the proportion of the projection vector onto xAxis, projection==xAxis * proportion
    func projectScaleToVector(xAxis:CGPoint) -> CGFloat {
        let d2 = xAxis.magnitudeSquared
        return d2 == 0 ? 0.0 : dotProduct(self, xAxis) / d2
    }
    
    //! Returns the projection vector and perpendicular vector, self==proj+perp
    func projectResolveVector(xAxis:CGPoint) -> (CGPoint, CGPoint) {
        let s = projectScaleToVector(xAxis)
        let proj = xAxis * s, perp = self - proj
        return (proj, perp)
    }
    
    //! Vector decomposition onto two vectors: self==u*uAxis + v*vAxis
    func resolveVector(uAxis:CGPoint, vAxis:CGPoint) -> (CGFloat, CGFloat) {
        let denom = crossProduct(uAxis, vAxis)
        if denom == 0 {
            return (0, 0)
        }
        let c = crossProduct(uAxis, self)
        return (crossProduct(self, vAxis) / denom, c / denom)  // (u,v)
    }
}
