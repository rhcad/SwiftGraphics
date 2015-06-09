//
//  ConvexHull.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public extension CGPoint {
    static func compareXY(lhs:CGPoint, rhs:CGPoint) -> Bool {
        return lhs.x < rhs.x ? true : (lhs.x == rhs.x ? (lhs.y < rhs.y ? true : false) : false)
    }
    static func compareYX(lhs:CGPoint, rhs:CGPoint) -> Bool {
        return lhs.y < rhs.y ? true : (lhs.y == rhs.y ? (lhs.x < rhs.x ? true : false) : false)
    }
}

// https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
public func monotoneChain(var points:[CGPoint], sorted:Bool = false) -> [CGPoint] {

    if points.count <= 3 {
        return points
    }

    if sorted == false {
        points.sortInPlace(CGPoint.compareXY)
    }

    var lower:[CGPoint] = []
    for var i = 0; i < points.count; i++ {
        while lower.count >= 2 && Turn(lower[lower.count - 2], lower[lower.count - 1], points[i])! != .Right {
            lower.removeLast()
        }
        lower.append(points[i])
    }
       
    var upper:[CGPoint] = []
    for var i = points.count - 1; i >= 0; i-- {
        while upper.count >= 2 && Turn(upper[upper.count - 2], upper[upper.count - 1], points[i])! != .Right {
            upper.removeLast()
            }
        upper.append(points[i]);
    }   

    lower.removeLast()
    upper.removeLast()

    let hull = lower + upper

    assert(hull.count <= points.count, "Ended up with more points in hull (\(hull.count)) than in origin set (\(points.count)).")

    return hull
}

