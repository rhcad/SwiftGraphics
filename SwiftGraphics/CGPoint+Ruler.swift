//
//  CGPoint+Ruler.swift
//  SwiftGraphics
//
//  Created by Zhang Yungui <https://github.com/rhcad> on 15/1/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics


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
